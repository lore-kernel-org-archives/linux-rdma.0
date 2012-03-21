From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [GIT PULL] please pull infiniband.git
Date: Wed, 21 Mar 2012 22:33:28 +0200
Message-ID: <CAJZOPZ+UFp9SWe71dnPxkmHPB4+7R+z=BvWwXiiMf9T0JC9s8A@mail.gmail.com>
References: <1332177079-14339-1-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1332177079-14339-1-git-send-email-roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Mar 19, 2012 at 7:11 PM, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:

> InfiniBand/RDMA changes for the 3.4 merge window. Nothing big really stands out; by
> patch count lots of fixes to the mlx4 driver plus some cleanups and fixes to the core
> and other drivers.

Hi Roland,

So again, any reason not to merge the RAW QP patches for 3.4? they
have been posted few months ago, its two kernel patches and we have
Sean's reviewd-by Signature for the core patch (see
http://marc.info/?l=linux-rdma&m=132693668105264&w=2)

The cover-letter (patch #0) at
http://marc.info/?l=linux-rdma&m=132680041724452&w=2

[PATCH 1/4] IB/core: add RAW Packet QP type
http://marc.info/?l=linux-rdma&m=132680053024484&w=2

[PATCH 2/4] IB/mlx4: add Raw Packet QP support
http://marc.info/?l=linux-rdma&m=132680061024504&w=2

patches 3 and 4 are for user-space, we can deal with them later.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
