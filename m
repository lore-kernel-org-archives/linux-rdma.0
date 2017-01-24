From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v3 00/37] IB: Optimize DMA mapping
Date: Tue, 24 Jan 2017 17:43:26 +0000
Message-ID: <1485279791.2715.3.camel@sandisk.com>
References: <20170120210437.26389-1-bart.vanassche@sandisk.com>
         <1485279487.43764.38.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1485279487.43764.38.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Content-ID: <E2DAB64D234FEB4295FD7D2AD1531D5A-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-01-24 at 12:38 -0500, Doug Ledford wrote:
> I think this has enough Acks to move foward (especially from the larger
> kernel community on the core kernel bits, such as GKH's ack on the core
> bits). =A0I've pulled it into a branch (there were a few fixups I had to
> do, compile testing that now). =A0However, I'm going to wait until the
> very end to merge this branch right before my pull request. =A0That way
> if Linus has any objections, he can just pop the top 37 patches off of
> my pull request and effectively remove this patchset, at which point we
> can fix up whatever he objected to and resubmit. =A0And I'm only doing
> that because of the number of patches that are either outside of
> drivers/infiniband or treewide in this series.

Hello Doug,

Waiting with a big patch series until the end of the merge window is the
traditional approach. A quote from https://lwn.net/Articles/585782/:
"Shortly after the -rc1 release is a good time for this, though it is best
to agree on this timing ahead of time." This makes me wonder whether we
should contact Linus before the next merge window opens?

Thanks,

Bart.=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
