From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 00/10] Hardware tag matching support
Date: Fri, 7 Oct 2016 17:56:20 +0300
Message-ID: <20161007145620.GV9282@leon.nu>
References: <1472382050-25908-1-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="BcZrms9gUsdgyR6a"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1472382050-25908-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--BcZrms9gUsdgyR6a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Aug 28, 2016 at 02:00:40PM +0300, Leon Romanovsky wrote:
> Message Passing Interface (MPI) is a communication protocol that is
> widely used for exchange of messages among processes in high-performance
> computing (HPC) systems. Messages sent from a sending process to a
> destination process are marked with an identifying label, referred to as
> a tag. Destination processes post buffers in local memory that are
> similarly marked with tags. When a message is received by the receiver
> (i.e., the host computer on which the destination process is running),
> the message is stored in a buffer whose tag matches the message tag. The
> process of finding a buffer with a matching tag for the received packet
> is called tag matching.
>
> There are two protocols that are generally used to send messages over
> MPI: The "Eager Protocol" is best suited to small messages that are
> simply sent to the destination process and received in an appropriate
> matching buffer. The "Rendezvous Protocol" is better suited to large
> messages. In Rendezvous, when the sender process has a large message to
> send, it first sends a small message to the destination process
> announcing its intention to send the large message. This small message
> is referred to as an RTS (ready to send) message. The RTS includes the
> message tag and buffer address in the sender. The destination process
> matches the RTS to a posted receive buffer, or posts such a buffer if
> one does not already exist. Once a matching receive buffer has been
> posted at the destination process side, the receiver initiates a remote
> direct memory access (RDMA) read request to read the data from the
> buffer address listed by the sender in the RTS message.
>
> MPI tag matching, when performed in software by a host processor, can
> consume substantial host resources, thus detracting from the performance
> of the actual software applications that are using MPI for
> communications. One possible solution is to offload the entire tag
> matching process to a peripheral hardware device, such as a network
> interface controller (NIC). In this case, the software application using
> MPI will post a set of buffers in a memory of the host processor and
> will pass the entire list of tags associated with the buffers to the
> NIC. In large-scale networks, however, the NIC may be required to
> simultaneously support many communicating processes and contexts
> (referred to in MPI parlance as "ranks" and "communicators,"
> respectively). NIC access to and matching of the large lists of tags
> involved in such a scenario can itself become a bottleneck. The NIC must
> also be able to handle "unexpected" traffic, for which buffers and tags
> have not yet been posted, which may also degrade performance.
>
> When the NIC receives a message over the network from one of the peer
> processes, and the message contains a label in accordance with the
> protocol, the NIC compares the label to the labels in the part of the
> list that was pushed to the NIC. Upon finding a match to the label, the
> NIC writes data conveyed in the message to the buffer in the memory that
> is associated with this label and submits a notification to the software
> process. The notification serves two purposes: both to indicate to the
> software process that the label has been consumed, so that the process
> will update the list of the labels posted to the NIC; and to inform the
> software process that the data are available in the buffer. In some
> cases (such as when the NIC retrieves the data from the remote node by
> RDMA), the NIC may submit two notifications, in the form of completion
> reports, of which the first informs the software process of the
> consumption of the label and the second announces availability of the
> data.
>
> This patch series adds to Mellanox ConnectX HCA driver support of
> tag matching. It introduces new hardware object eXtended shared Receive
> Queue (XRQ), which follows SRQ semantics with addition of extended
> receive buffers topologies and offloads. This series adds tag matching
> topology and rendezvouz offload.
>
> Available in the "topic/xrq" topic branch of this git repo:
> git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git
>
> Or for browsing:
> https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/?h=topic/xrq

Hi Doug,

For any reasons, I don't see this patch set in your tree. Did I miss it?

Thanks

>
> Thanks,
>   Artemy & Leon
>
> Artemy Kovalyov (10):
>   IB/core: Add XRQ capabilities
>   IB/core: Make CQ separate part of SRQ context
>   IB/core: Add new SRQ type IB_SRQT_TAG_MATCHING
>   IB/uverbs: Expose tag matching capabilties to UAPI
>   IB/uverbs: Expose XRQ capabilities
>   IB/uverbs: Add XRQ creation parameter to UAPI
>   IB/uverbs: Add new SRQ type IB_SRQT_TAG_MATCHING
>   IB/mlx5: Fill XRQ capabilities
>   net/mlx5: Add XRQ support
>   IB/mlx5: Support IB_SRQT_TAG_MATCHING
>
>  drivers/infiniband/core/uverbs_cmd.c          |  31 +++++-
>  drivers/infiniband/core/verbs.c               |  16 +--
>  drivers/infiniband/hw/mlx5/main.c             |  21 +++-
>  drivers/infiniband/hw/mlx5/mlx5_ib.h          |   6 ++
>  drivers/infiniband/hw/mlx5/srq.c              |  15 ++-
>  drivers/net/ethernet/mellanox/mlx5/core/srq.c | 150 ++++++++++++++++++++++++--
>  include/linux/mlx5/driver.h                   |   1 +
>  include/linux/mlx5/srq.h                      |   5 +
>  include/rdma/ib_verbs.h                       |  61 +++++++++--
>  include/uapi/rdma/ib_user_verbs.h             |  36 ++++++-
>  10 files changed, 307 insertions(+), 35 deletions(-)
>
> --
> 2.7.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--BcZrms9gUsdgyR6a
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX97eUAAoJEORje4g2clinSeYP/0tDKPiP3bNqv1B8BMNm4bx8
WJrX8OV4OFHn9bjVVRzq6v1dYfXEeznKyhZVZGBEVvuvJCpvZj5U5h5i5aXqm6Bb
R9dK90+VjfPHZV3DX7qTJGm0O2HXiojL8jlQ7teDwtMav6YG2dnXyOikvYJgCts4
MKmEFlZXDkZihZ12bAjKdjsg7EoIbG2tyn5ZFdjJapDsNRfXuUkJXuOyLZCH5fF5
dluXGVHM8BfCiJZj+LJ5oNkKLKYpHGPngmx20H7m/cPhaYZodC8mUCd/GrOXZOL+
s/2ihDsPNa1cOZBMLNSdxjtdLmnJgzgjtVzBqoBfGKHYNIbaA48MMCFlXj17YaMh
riTttvzCGcPS8MLUx0YVjASS7TolCTmTVOcbbPAp3jptDV9matSNsrCPPZaEUBVh
tCbmvyvIeYtdY6SfFvdKXRpe8NZZNPMmphHKhK+pZt/5AhBHWiOnDSa9tWvgNXT6
wY5NHjlQk05kDsOJITdxxYJQnMhay8OBOHCwyD89XcRd6jGD1eqy/667inXCAw2w
y6WMCdhWGpw5+tbrJ8R8Gdbjd/SwwAOBdWwwdXKB3DX6TQv1YaVLCSRQOkFfy23G
5OY5HUcu8MzxhEm1jLv8q2/JfURtDuyak90btxAk45F+tygE2hUtURcluu8SpPkn
kpuH9xaFhpKMqrM3xk9Y
=1f7+
-----END PGP SIGNATURE-----

--BcZrms9gUsdgyR6a--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
