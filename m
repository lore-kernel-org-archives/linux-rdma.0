From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next V1 0/9] Add RoCE v2 support
Date: Sun, 22 Nov 2015 23:28:51 +0200
Message-ID: <CAJ3xEMiAkz0aouPgHWD31CwrX4SmOQfysJBX2kQOZ91gVP+94g@mail.gmail.com>
References: <1444925232-13598-1-git-send-email-matanb@mellanox.com>
	<CAAKD3BBm2WZ8TqSFi7gC82BwBTCc+D-SJSpSSqhEqMjL8-Fq_A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAAKD3BBm2WZ8TqSFi7gC82BwBTCc+D-SJSpSSqhEqMjL8-Fq_A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 16, 2015, Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> On Thu, Oct 15, 2015 , Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:

>> Hi Doug,
>> This series adds the support for RoCE v2. In order to support RoCE v2,
>> we add gid_type attribute to every GID. When the RoCE GID management
>> populates the GID table, it duplicates each GID with all supported types.
>> This gives the user the ability to communicate over each supported type.

> Hi Doug,
> This series was posted a month ago.
> If you have any comments, I would appreciate if you could please post them.

Doug,

Correction. The series was posted on Aug 13 -- three months ago, see [1].

I think it's terribly fair enough to know where it stands w.r.t
deployment into 4.5

Lack of RoCE v2 support in the IB core is slowing down the RocE
support for mlx5 and adoption of Soft-RoCE, it's fair enough to ask
for you as maintainer to react/respond after three months the patches
are waiting.

Or.

[1] http://marc.info/?l=linux-rdma&m=143948192926723&w=2

> Otherwise, could we please push this series to v4.5?
> If you need, I can rebase it over your for-4.5 branch once you'll open
> such a branch.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
