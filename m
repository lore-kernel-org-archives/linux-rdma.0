From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [ofw] [Patch] [Tools][infiniband-diags]
Date: Wed, 25 Aug 2010 20:20:34 +0300
Message-ID: <20100825172034.GN5837@me>
References: <E113D394D7C5DB4F8FF691FA7EE9DB443B390460E6@MTLMAIL.mtl.com>
 <20100801171938.GB26625@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100801171938.GB26625@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Irena Kruchkovsky <irena-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 20:19 Sun 01 Aug     , Sasha Khapyorsky wrote:
> On 14:36 Wed 28 Jul     , Irena Kruchkovsky wrote:
> > A patch that fixes the GUID output in ibstat to work correctly in windows 2003.
> > 
> > Index: D:/Windows/MLNX_VPI/tools/infiniband-diags/src/ibstat.c
> > ===================================================================
> > --- D:/Windows/MLNX_VPI/tools/infiniband-diags/src/ibstat.c  (revision 6199)
> > +++ D:/Windows/MLNX_VPI/tools/infiniband-diags/src/ibstat.c               (revision 6200)
> > @@ -72,9 +72,9 @@
> >                 printf("\tNumber of ports: %d\n", ca->numports);
> >                 printf("\tFirmware version: %s\n", ca->fw_ver);
> >                 printf("\tHardware version: %s\n", ca->hw_ver);
> > -              printf("\tNode GUID: 0x%016llx\n",
> > +             printf("\tNode GUID: 0x%016I64x\n",
> 
> Normally we are using PRI* macros with management code. What about this:

I've commited this couple of days ago:

commit e4b73c2081a9afc346adf98d0f4d348005c920f6
Author: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Date:   Sun Aug 1 20:26:11 2010 +0300

    infiniband-diags/ibstat: convert to PRIx64 macros GUID printing
    
    Convert to using PRIx64 macros for printing GUID values.
    
    Pointed out by Irena Kruchkovsky.
    
    Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>

diff --git a/infiniband-diags/src/ibstat.c b/infiniband-diags/src/ibstat.c
index c44d8c4..f655a13 100644
--- a/infiniband-diags/src/ibstat.c
+++ b/infiniband-diags/src/ibstat.c
@@ -72,10 +72,9 @@ static void ca_dump(umad_ca_t * ca)
 	printf("\tNumber of ports: %d\n", ca->numports);
 	printf("\tFirmware version: %s\n", ca->fw_ver);
 	printf("\tHardware version: %s\n", ca->hw_ver);
-	printf("\tNode GUID: 0x%016llx\n",
-	       (long long unsigned)ntohll(ca->node_guid));
-	printf("\tSystem image GUID: 0x%016llx\n",
-	       (long long unsigned)ntohll(ca->system_guid));
+	printf("\tNode GUID: 0x%016" PRIx64 "\n", ntohll(ca->node_guid));
+	printf("\tSystem image GUID: 0x%016" PRIx64 "\n",
+	       ntohll(ca->system_guid));
 }
 
 static char *port_state_str[] = {
@@ -122,8 +121,7 @@ static int port_dump(umad_port_t * port, int alone)
 	printf("%sLMC: %d\n", pre, port->lmc);
 	printf("%sSM lid: %d\n", pre, port->sm_lid);
 	printf("%sCapability mask: 0x%08x\n", pre, ntohl(port->capmask));
-	printf("%sPort GUID: 0x%016llx\n", pre,
-	       (long long unsigned)ntohll(port->port_guid));
+	printf("%sPort GUID: 0x%016" PRIx64 "\n", pre, ntohll(port->port_guid));
 	printf("%sLink layer: %s\n", pre, port->link_layer);
 	return 0;
 }
@@ -182,8 +180,7 @@ static int ports_list(char names[][UMAD_CA_NAME_LEN], int n)
 
 	for (i = 0; i < found; i++)
 		if (guids[i])
-			printf("0x%016llx\n",
-			       (long long unsigned)ntohll(guids[i]));
+			printf("0x%016" PRIx64 "\n", ntohll(guids[i]));
 	return found;
 }


, hope this solves your issues too.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
