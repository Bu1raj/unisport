import express from 'express';
import * as db from './database.js';
const PORT = 3000
const app = express()

//middlewear
app.use(express.json());

//////////////////////////////// issue return section ////////////////////////////////////////
//map
app.get("/map", async (req, res) => {
    const map = await db.getSportsEquipmentsMap();
    res.status(200).send(map)
})

//get free equipments
app.get("/inventory/freeEquipments/:sport/:equipment", async(req, res) => {
    const {sport, equipment} = req.params
    const list = await db.getFreeEquipmentIds(sport, equipment)
    res.status(200).send(list)
})

app.post("/returnScreen/details", async(req, res) => {
    try{
        const {idList} = req.body
        const result = await db.fetchCorrespondingEquipmentNames(idList)
        console.log(result)
        res.status(200).send(result)
    }catch(e){
        res.status(500).json({error : e.message});
    }
})

//change issued items status
app.post("/inventory/editIssued", async(req, res) => {
    try{
        const {idList} = req.body
        await db.editIssued(idList)
        res.status(200).send({msg: 'Issued -> True'})
    }catch(e){
        res.status(500).json({error : e.message});
    }
})

app.post("/inventory/freeIssued", async(req, res) => {
    try{
        const {idList} = req.body
        await db.freeIssued(idList)
        res.status(200).send({msg: 'Issued -> False'})
    }catch(e){
        res.status(500).json({error : e.message});
    }
})


////////////////////////////// inventory management //////////////////////////////////////////////

app.get("/mainInventory/getInventory/:sport/:equipment", async(req, res) => {
    try{
        const {sport, equipment} = req.params
        const result = await db.fetchMainInventoryOfASport(sport, equipment)
        res.status(200).send(result)
    }catch(e){
        res.status(500).json({error : e.message});
    }
})

app.post("/mainInventory/addNewStock", async(req, res) => {
    try{
        const {itemsToBeAdded} = req.body
        console.log(itemsToBeAdded)
        const result = await db.addNewStock(itemsToBeAdded)
        res.status(200).send({msg: 'Items added'})
    }catch(e){
        res.status(500).json({error : e.message});
    }
})

app.post("/mainInventory/changeStatus", async(req, res) => {
    try{
        const {equipmentId, status} = req.body
        console.log(`${equipmentId} ${status}`)
        const result = await db.updateStatus(equipmentId, status)
        res.status(200).send({msg: 'Status Updated'})
    }catch(e){
        res.status(500).json({error : e.message});
    }
})

app.post("/mainInventory/editInUse", async(req, res) => {
    try{
        const {newStockIds} = req.body
        const result = await db.editInUse(newStockIds)
        res.status(200).send({msg : 'added to inUSe'})
    }catch(e){
        res.status(500).json({error : e.message});
    }
})

////////////////////////////////// arena management //////////////////////////////////////////

app.get("/arenaManagement/getSports", async(req, res) => {
    try{
        const result = await db.getArenaSports()
        res.status(200).send(result)
    }catch(e){
        res.status(500).json({error : e.message});
    }
})

app.get("/arenaManagement/getArenas/:sport", async(req, res) => {
    try{
        const {sport} = req.params
        const result = await db.getArenaOfASport(sport)
        res.status(200).send(result)
    }catch(e){
        res.status(500).json({error : e.message});
    }
})

app.get("/arenaManagement/getSlotDetails/:arenaId", async(req, res) => {
    try{
        const {arenaId} = req.params
        const result = await db.getSlotDetails(arenaId)
        res.status(200).send(result)
    }catch(e){
        res.status(500).json({error : e.message});
    }
})

app.post("/arenaManagement/bookASlot", async(req, res) => {
    try{
        const {slotNo, arenaId, bookedBy} = req.body
        const result = await db.bookASlot(slotNo, arenaId, bookedBy)
        res.status(200).send({msg: 'Booked successfully'})
    }catch(e){
        res.status(500).json({error : e.message});
    }
})

app.get("/arenaManagement/getBookedSlotDetails/:usn", async(req, res) => {
    try{
        const {usn} = req.params
        const result = await db.bookedSlotDetails(usn)
        res.status(200).send(result)
    }catch(e){
        res.status(500).json({error : e.message});
    }
});

app.post("/arenaManagement/cancelBooking", async(req, res) => {
    try{
        const {bookedBy} = req.body
        const result = await db.cancelBooking(bookedBy)
        res.status(200).send({msg: 'Booking cancelled'})
    }catch(e){
        res.status(500).json({error : e.message});
    }
});

app.listen(PORT, "0.0.0.0", () => {
    console.log(`connected at port ${PORT}`);
});

