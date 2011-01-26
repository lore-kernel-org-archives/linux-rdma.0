From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V2] IB/ipoib: Leave stale send-only multicast groups
Date: Wed, 26 Jan 2011 12:26:12 -0600 (CST)
Message-ID: <alpine.DEB.2.00.1101261224370.23080@router.home>
References: <4D34239D.9030004@Voltaire.COM> <alpine.DEB.2.00.1101181406490.18059@router.home> <AANLkTiku+dkiqsv1AKUr_wCVhxWFhay0HEuSZtt7uZWr@mail.gmail.com> <alpine.DEB.2.00.1101260954420.23080@router.home>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.00.1101260954420.23080-sBS69tsa9Uj/9pzu0YdTqQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yossi Etigin <yosefe-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Well turns out that my tests just proves that the patch works as
intended. After all we run Voltaire OFED which has had a similar patch to
address the issue for a long time.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
