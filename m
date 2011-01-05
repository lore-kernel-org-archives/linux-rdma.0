From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/24] various fixes for QIB driver
Date: Wed, 05 Jan 2011 10:07:30 -0800
Message-ID: <adahbdnfcm5.fsf@cisco.com>
References: <20101228152648.19960.84006.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101228152648.19960.84006.stgit-hIFRcJ1SNwcXGO8/Qfapyjg/wwJxntczYPYVAmT7z5s@public.gmane.org>
	(Mike Marciniszyn's message of "Tue, 28 Dec 2010 10:26:50 -0500")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

OK, I applied the whole list except for

IB/qib: add thresholds to VendorPortCounters PMA operation

and I collapsed

IB/qib: Add a delay to allow SERDES to initialize
IB/qib: Improve SERDES tunning on QMH boards

into one patch.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
