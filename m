From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 2/6] IB/core: fix wrong display of rate in sysfs
Date: Tue, 28 Feb 2012 17:17:54 +0200
Message-ID: <alpine.LRH.2.00.1202281717420.27988@ogerlitz.voltaire.com>
References: <alpine.LRH.2.00.1201111850330.10264@ogerlitz.voltaire.com> <alpine.LRH.2.00.1201111856160.10264@ogerlitz.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LRH.2.00.1201111856160.10264-VYr5/9ddeaGSIdy2EShu12Xnswh1EIUO@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> If no one has a problem, I'll just go ahead with the following...

Roland, here's your patch fixed to work, this function is something...
you've missed a break in the SDR switch case.. I added it and tested

Or.

--

    IB/core: Fix SDR rates in sysfs

    Commit 71eeba16 ("IB: Add new InfiniBand link speeds") introduced a bug
    where eg the rate for IB 4X SDR links iss displayed as "8.5 Gb/sec"
    instead of "10 Gb/sec" as it used to be.  Fix that.

    Reported-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
    Signed-off-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>

Index: linux-2.6/drivers/infiniband/core/sysfs.c
===================================================================
--- linux-2.6.orig/drivers/infiniband/core/sysfs.c
+++ linux-2.6/drivers/infiniband/core/sysfs.c
@@ -179,33 +179,37 @@ static ssize_t rate_show(struct ib_port
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
+		speed = " SDR";
+		rate = 25;
+		break;
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

@@ -214,7 +218,7 @@ static ssize_t rate_show(struct ib_port
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
