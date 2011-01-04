From: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH 24/24] IB/qib: Improve SERDES tunning on QMH boards
Date: Tue, 4 Jan 2011 10:59:28 -0800
Message-ID: <35AAF1E4A771E142979F27B51793A4888837F70142@AVEXMB1.qlogic.org>
References: <20101228152648.19960.84006.stgit@kop-dev-sles11-04.qlogic.org>
	<20101228152855.19960.96651.stgit@kop-dev-sles11-04.qlogic.org>
 <adalj30ijnc.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adalj30ijnc.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I noticed that, but was concerned with conflicts, which there are none in this case.

23 and 24 can combined to get rid of the hunk below.   I have no issue with losing the history for 23.

Mike

-----Original Message-----
From: Roland Dreier [mailto:rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org] 
Sent: Tuesday, January 04, 2011 1:55 PM
To: Mike Marciniszyn
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Re: [PATCH 24/24] IB/qib: Improve SERDES tunning on QMH boards

 > @@ -7596,8 +7616,6 @@ static int serdes_7322_init_new(struct qib_pportdata *ppd)
 >  	/* VGA output common mode */
 >  	ibsd_wr_allchans(ppd, 12, (3 << 2), BMASK(3, 2));
 >  
 > -	/* Add a delay to allow the SERDES to init */
 > -	msleep(3000);
 >  	return 0;
 >  }

Am I confused or is this chunk completely reverting patch 23?  Is there
any reason you want that patch in the kernel history?

 - R.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
