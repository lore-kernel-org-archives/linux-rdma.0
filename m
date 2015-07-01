From: Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: [PATCH V3 4/4] RDMA/isert: Support iWARP transport
Date: Wed, 1 Jul 2015 23:33:26 +0300
Message-ID: <CAJ3xEMjWVwbW0sgVsMj3hPLMRZgJ8srMG89gYzUEbvQAHBaUEw@mail.gmail.com>
References: <20150701162936.6501.45512.stgit@build.ogc.int>
	<20150701163058.6501.39171.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20150701163058.6501.39171.stgit@build.ogc.int>
Sender: target-devel-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>
Cc: Doug Ledford <dledford@redhat.com>, Roi Dayan <roid@mellanox.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Sagi Grimberg <sagig@mellanox.com>, Mike Marciniszyn <infinipath@intel.com>, target-devel@vger.kernel.org, Eli Cohen <eli@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jul 1, 2015 at 7:30 PM, Steve Wise <swise@opengridcomputing.com> wrote:
> Memory regions that are the target of an iWARP RDMA READ RESPONSE need
> REMOTE_WRITE access rights.  So enable REMOTE_WRITE for iWARP devices.

I don't see the point to mess the code with this branching on the
iwarp specific diffs from IB/RoCE -- note that the MRs for which you
mangle their access flags are LOCAL and not advertised to external
entity (initiator), hence why not just OR into the access flags what
iwarp needs?!

> Use the device's max_sge_rd capability to compute the target's read sge
> depth.  Save both the read and write max_sge values in the isert_conn
> struct, and use these when creating RDMA_READ work requests

We have here strictly two related but different changes, break this to
two patches.

> +static int any_port_is_iwarp(struct isert_device *device)
> +{
> +       int i;
> +
> +       for (i = rdma_start_port(device->ib_device);
> +            i <= rdma_end_port(device->ib_device); i++)
> +               if (rdma_protocol_iwarp(device->ib_device, i))
> +                       return 1;
> +       return 0;
> +}
> +

If this needed @ all, put in one of the IB core headers, not in a ULP source
