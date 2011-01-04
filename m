From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 24/24] IB/qib: Improve SERDES tunning on QMH boards
Date: Tue, 04 Jan 2011 10:55:03 -0800
Message-ID: <adalj30ijnc.fsf@cisco.com>
References: <20101228152648.19960.84006.stgit@kop-dev-sles11-04.qlogic.org>
	<20101228152855.19960.96651.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101228152855.19960.96651.stgit-hIFRcJ1SNwcXGO8/Qfapyjg/wwJxntczYPYVAmT7z5s@public.gmane.org>
	(Mike Marciniszyn's message of "Tue, 28 Dec 2010 10:28:55 -0500")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

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
