import mysql from 'mysql2';

import dotenv from 'dotenv';
dotenv.config()


const pool = mysql.createPool({
    host: process.env.MYSQL_HOST,
    user: process.env.MYSQL_USER,
    password: process.env.MYSQL_PASSWORD,
    database: process.env.MYSQL_DATABASE,
}).promise()

////////////// Issue return //////////////////////////////

export async function getSportsEquipmentsMap(){
    const result = await pool.query(`SELECT * FROM sports_equipments`)
    return result[0]
}

export async function getFreeEquipmentIds(sport, equipment){
    const result = await pool.query(
        `SELECT equipmentId
        FROM main_inventory
        WHERE
        sport = ? AND equipmentName = ? AND statusEq = 'inUse' AND issued = 0
        `, [sport, equipment]
    )
    
    const ids = [];
    
    for(let i = 0; i < result[0].length; i++){
        ids.push(result[0][i].equipmentId)
    }
    return ids
}

export async function fetchCorrespondingEquipmentNames(idList){
    const result = await pool.query(
        `SELECT equipmentId, equipmentName
        FROM main_inventory
        WHERE
        equipmentId IN (?)`, [idList]
    )

    const id_names_map = {};

    for(let i = 0; i < result[0].length; i++){
        id_names_map[result[0][i].equipmentId]  = result[0][i].equipmentName
    }

    return id_names_map
}

export async function editIssued(idList){
    const result = await pool.query(
        `UPDATE main_inventory
        SET issued = 1
        WHERE
        equipmentId IN (?)`, [idList]
    )
}

export async function freeIssued(idList){
    const result = await pool.query(
        `UPDATE main_inventory
        SET issued = 0
        WHERE
        equipmentId IN (?)`, [idList]
    )

    //return result[0]
}

///////////////////////////// Inventory Management ////////////////////////////////////////////////

export async function fetchMainInventoryOfASport(sport, equipment){
    const result = await pool.query(
        `SELECT equipmentId, equipmentName, sport, startedUsingOn, statusEq
        FROM main_inventory
        WHERE
        sport = ? AND equipmentName = ?`,
        [sport, equipment]
    )

    return result[0]
}

export async function addNewStock(itemsToBeAdded){
    const result = await pool.query(
        `INSERT INTO main_inventory (equipmentId, equipmentName, sport, startedUsingOn, statusEq, issued)
        VALUES ?`, [itemsToBeAdded]
    )

    return result[0]
}

export async function updateStatus(equipmentId, status){
    const result = await pool.query(
        `UPDATE main_inventory
        SET statusEq = ?
        WHERE
        equipmentId = ?`, [status, equipmentId]
    )
}

export async function editInUse(newStockIds){
    await pool.query(`UPDATE main_inventory
    SET statusEq = 'inUse'
    WHERE
    equipmentId IN (?)`, [newStockIds]
    )
}

///////////////////////////////////// arena management /////////////////////////////////////////////////

export async function getArenaSports(){
    const result = await pool.query(
    `SELECT
    DISTINCT(sport) FROM arena`
    )
    return result[0]
}

export async function getArenaOfASport(sport){
    const result = await pool.query(
        `SELECT
        arenaId, arenaName
        FROM arena
        WHERE
        sport = ?`, [sport]
    )
    return result[0]
}

export async function getSlotDetails(arenaId){
    const result = await pool.query(
        `SELECT
        *
        FROM arena_slots
        WHERE
        arenaId = ?`, [arenaId]
    )
    return result[0]
}

export async function bookASlot(slotNo, arenaId, bookedBy){
    const result = await pool.query(
        `UPDATE
        arena_slots
        SET bookedBy = ?
        WHERE
        slotNo = ?
        AND
        arenaId = ?`, [bookedBy, slotNo, arenaId]
    )
}

/*const eqpList = await getArenaSports();
console.log(eqpList);*/