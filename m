From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4] IB/IPoIB: ibX: failed to create mcg debug file
Date: Wed, 05 Apr 2017 13:51:01 -0400
Message-ID: <1491414661.2923.1.camel@redhat.com>
References: <1490782919-24910-1-git-send-email-shamir.rabinovitch@oracle.com>
         <06c3788d-d99b-025d-943e-1eb7d1a38dca@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <06c3788d-d99b-025d-943e-1eb7d1a38dca-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shamir Rabinovitch <shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: vijay.ac.kumar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, 2017-03-29 at 16:20 +0300, Mark Bloch wrote:
> I know the commit that added debugfs is older than the universe, but
> maybe you can
> use the commit below as a fixes line/queue it to stable?
> 
> commit 1732b0ef3b3a02e3df328086fb3018741c5476da
> Author: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
> Date:   Mon Nov 7 10:33:11 2005 -0800

I added a Fixes: and Cc: tags for stable, patch applied, thanks.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
