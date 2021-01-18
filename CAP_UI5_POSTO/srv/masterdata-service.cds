using capui5 as capui5 from '../db/schema';

service MasterData {
    entity Client as projection on capui5.Client;    
}
