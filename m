From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHv2 1/1] IB/ipoib: add get_settings in ethtool
Date: Mon, 01 May 2017 14:59:15 -0400
Message-ID: <1493665155.3041.186.camel@redhat.com>
References: <1493197354-3025-1-git-send-email-yanjun.zhu@oracle.com>
         <20170426113125.b7d64c5b0760e0316e6aedf6@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170426113125.b7d64c5b0760e0316e6aedf6-l3A5Bk7waGM@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Bogendoerfer <tbogendoerfer-l3A5Bk7waGM@public.gmane.org>, Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, haakon.bugge-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, joe.jin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, junxiao.bi-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, 2017-04-26 at 11:31 +0200, Thomas Bogendoerfer wrote:
> On Wed, 26 Apr 2017 05:02:34 -0400
> Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> 
> > 
> > In order to let the bonding driver report the correct speed
> > of the underlaying interfaces, when they are IPoIB, the ethtool
> > function get_settings() in the IPoIB driver is implemented.
> 
> FYI get_settings is DEPRECATED. Wouldn't it make more sense to
> directly
> implement get_link_ksettings ?

Indeed, please redo this patchset using the preferred method of getting
link settings.  Thanks.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
