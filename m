From: Thomas Bogendoerfer <tbogendoerfer-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCHv2 1/1] IB/ipoib: add get_settings in ethtool
Date: Wed, 26 Apr 2017 11:31:25 +0200
Message-ID: <20170426113125.b7d64c5b0760e0316e6aedf6@suse.de>
References: <1493197354-3025-1-git-send-email-yanjun.zhu@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1493197354-3025-1-git-send-email-yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, haakon.bugge-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, joe.jin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, junxiao.bi-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, 26 Apr 2017 05:02:34 -0400
Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:

> In order to let the bonding driver report the correct speed
> of the underlaying interfaces, when they are IPoIB, the ethtool
> function get_settings() in the IPoIB driver is implemented.

FYI get_settings is DEPRECATED. Wouldn't it make more sense to directly
implement get_link_ksettings ?

Thomas.

-- 
SUSE Linux GmbH
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
