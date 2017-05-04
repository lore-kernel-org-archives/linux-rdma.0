From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHv3 1/1] IB/ipoib: add get_link_ksettings in ethtool
Date: Thu, 04 May 2017 19:45:50 -0400
Message-ID: <1493941550.3041.235.camel@redhat.com>
References: <1493665155.3041.186.camel@redhat.com>
         <1493875491-32048-1-git-send-email-yanjun.zhu@oracle.com>
         <1493875491-32048-2-git-send-email-yanjun.zhu@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1493875491-32048-2-git-send-email-yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, tbogendoerfer-l3A5Bk7waGM@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, haakon.bugge-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
Cc: joe.jin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, junxiao.bi-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-05-04 at 01:24 -0400, Zhu Yanjun wrote:
> In order to let the bonding driver report the correct speed
> of the underlaying interfaces, when they are IPoIB, the ethtool
> function get_link_ksettings() in the IPoIB driver is implemented.
> 
> Cc: Joe Jin <joe.jin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Cc: Junxiao Bi <junxiao.bi-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Suggested-by: Håkon Bugge <Haakon.Bugge-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Thanks.  Since I had a second pull request to send this merge window,
I've taken this in for that pull request.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
