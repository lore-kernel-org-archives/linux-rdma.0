From: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH V1 for-next 6/9] IB/core: Sysfs support for peer memory
Date: Tue, 7 Oct 2014 12:33:27 +0000
Message-ID: <c0225a91ac384a8e86893ada1c3b429a@AMSPR05MB422.eurprd05.prod.outlook.com>
References: <1412602019-30659-1-git-send-email-yishaih@mellanox.com>
 <1412602019-30659-7-git-send-email-yishaih@mellanox.com>
 <20141006210023.GC28962@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141006210023.GC28962-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Jason Gunthorpe
> Sent: Tuesday, October 07, 2014 12:00 AM
> To: Yishai Hadas
> Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Shachar Raindel
> Subject: Re: [PATCH V1 for-next 6/9] IB/core: Sysfs support for peer
> memory
> 
> On Mon, Oct 06, 2014 at 04:26:56PM +0300, Yishai Hadas wrote:
> > new file mode 100644
> > index 0000000..c09cde2
> > +++ b/Documentation/infiniband/peer_memory.txt
> 
> Um, no, these belong in Documentation/ABI/stable/sysfs-*
> 

I think that we should first make sure the ABI here is usable and not
missing anything, and only afterwards start documenting it as
stable. If you prefer that we add the documentation to
Documentation/ABI/testing/sysfs-*, instead of documenting it in a
feature specific location, we can do so.

> Please explain why these should not be in debugfs.
> 

The counters exposed provide information that are useful for a normal
user application, similarly to the amount of free memory in the
system, /proc/meminfo or the cpu usage information. For example, a
user application can decide to avoid using peer direct if too much
memory is currently pinned, falling back to performing memory
copy. The peer identity and version detection is also useful for
similar runtime decisions, for example the application will use peer
direct only if the peer is supporting it, and the version is known not
to contain critical bugs (black/white list for peer direct
versions). Using debugfs will require root permissions to do such
actions, making application deployment and automatic tuning harder.

> You are going to need to get someone other than Roland to sign off on
> '/sys/kernel/mm/memory_peers'.
> 

As the peers are usually not tied to a specific RDMA card, we wanted a
location that is shared between all RDMA capable cards. We will
happily relocate the sysfs files to a location under the infiniband
class if this will accelerate the review process.

> Actually, I'm skeptical this whole scheme even belongs under
> Infiniband. Why couldn't this be used to read from a file with
> O_DIRECT into a GPU, for instance?
> 

Indeed, the challenge of doing peer to peer transactions can exist in
other parts of the kernel as well. However, the RDMA programming model
presents unique requirements, that imposes a highly tailored
solution. For example, the long life time of memory registration in
RDMA, which can reach days and months. This is relatively to the
extreme short life time of memory pinning in other applications such
as O_DIRECT. This long life time raises the need for interfaces such
as the invalidation flow. For this reason, we believe that the
suggested solution should be placed under the infiniband tree. If a
storage vendor is interested in doing peer to peer transactions as
well, we will happily review his patches.

> Did you try to find a better home for this?
> 

See above. In short - some of the features included here might be
useful elsewhere. However, we feel that there are enough unique
requirements in the RDMA case to justify defining an explicit
interface here.

--Shachar
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
