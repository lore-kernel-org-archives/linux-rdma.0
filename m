From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/6] IB/core: fix wrong display of rate in sysfs
Date: Mon, 27 Feb 2012 09:23:42 -0800
Message-ID: <CAL1RGDWNh1_fFWS=gMxo8vm-n46TOTxbu+GmRNE1YEmAyuE1Tw@mail.gmail.com>
References: <alpine.LRH.2.00.1201111850330.10264@ogerlitz.voltaire.com>
 <alpine.LRH.2.00.1201111856160.10264@ogerlitz.voltaire.com>
 <1828884A29C6694DAF28B7E6B8A82373256757DB@ORSMSX101.amr.corp.intel.com>
 <CAJZOPZJHbuyfXbQdEQ3QZt3O+bLTdzpBJOfUmB-Rqrvi9WUXuQ@mail.gmail.com> <4F49EBD1.7030900@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F49EBD1.7030900-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Could you please let me know if you want a change in this patch, or this fix
> can go in using the current form for 3.4?

It doesn't really work if everything needs me to micromanage every step...
the original patch obviously made some ugly code uglier, Sean pointed out an
obvious way to make things cleaner.

If no one has a problem, I'll just go ahead with the following...

--

    IB/core: Fix SDR rates in sysfs

    Commit 71eeba16 ("IB: Add new InfiniBand link speeds") introduced a bug
    where eg the rate for IB 4X SDR links iss displayed as "8.5 Gb/sec"
    instead of "10 Gb/sec" as it used to be.  Fix that.

    Reported-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
    Signed-off-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>

diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index c61bca3..29cd9d5 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -179,33 +179,36 @@ static ssize_t rate_show(struct ib_port *p,
struct port_attribute *unused,
 {
 	struct ib_port_attr attr;
 	char *speed = "";
-	int rate;
+	int rate = -1;		/* in deci-Gb/sec */
 	ssize_t ret;

 	ret = ib_query_port(p->ibdev, p->port_num, &attr);
 	if (ret)
 		return ret;

-	rate = (25 * attr.active_speed) / 10;
-
 	switch (attr.active_speed) {
+	case 1:
+		/* SDR */
+		rate = 25;
 	case 2:
 		speed = " DDR";
+		rate = 50;
 		break;
 	case 4:
 		speed = " QDR";
+		rate = 100;
 		break;
 	case 8:
 		speed = " FDR10";
-		rate = 10;
+		rate = 100;
 		break;
 	case 16:
 		speed = " FDR";
-		rate = 14;
+		rate = 140;
 		break;
 	case 32:
 		speed = " EDR";
-		rate = 25;
+		rate = 250;
 		break;
 	}

@@ -214,7 +217,7 @@ static ssize_t rate_show(struct ib_port *p, struct
port_attribute *unused,
 		return -EINVAL;

 	return sprintf(buf, "%d%s Gb/sec (%dX%s)\n",
-		       rate, (attr.active_speed == 1) ? ".5" : "",
+		       rate / 10, rate % 10 ? ".5" : "",
 		       ib_width_enum_to_int(attr.active_width), speed);
 }
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
