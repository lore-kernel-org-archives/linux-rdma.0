From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH for-3.2 v1 1/5] ib/core: Add extended link speeds
Date: Mon, 3 Oct 2011 23:50:13 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E691FF@ORSMSX101.amr.corp.intel.com>
References: <201110031754.59246.marcela@dev.mellanox.co.il>
 <1828884A29C6694DAF28B7E6B8A8237316E690F8@ORSMSX101.amr.corp.intel.com>
 <CAG4TOxN8FYggab5Juk+VhSbbQ5a8mn0KJGM4=7uJB0Df8rpA4g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG4TOxN8FYggab5Juk+VhSbbQ5a8mn0KJGM4=7uJB0Df8rpA4g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Marcel Apfelbaum <marcela-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "marcela-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <marcela-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Why not just define this function to return the rate in units where
> it's a whole number?
> ie just have the function return the value in Mbps instead of Gbps, so
> it returns
> 2500, 5000, etc. instead of 2+(*rounded=5), 5+(*rounded=0), etc.

even simpler!

> > Or if ib_rate_to_int() is only used to convert the rate into a string, we
> could just return the string directly.
> 
> Maybe... I think it gets used in IPoIB too if I didn't misread things.

ipoib just converts it to a string, and I didn't see any other users of it.

+		rate = ib_rate_to_int(path.pathrec.rate, &rate_rounded);
 
 		seq_printf(file,
 			   "  DLID:     0x%04x\n"
@@ -220,8 +221,8 @@ static int ipoib_path_seq_show(struct se
 			   "  rate: %*d%s Gb/sec\n",
 			   be16_to_cpu(path.pathrec.dlid),
 			   path.pathrec.sl,
-			   10 - ((rate % 10) ? 2 : 0),
-			   rate / 10, rate % 10 ? ".5" : "");
+			   10 - (rate_rounded ? 2 : 0),
+			   rate, rate_rounded ? ".5" : "");
 	}
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
