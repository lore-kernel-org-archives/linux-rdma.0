Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795519643;
	b=ecPrUNPv9OxGPQizr0YVsbN5FxEvoVrivYNmfs2Qdb9hobehrV3IyQNoqH47RVDZXHBG
	 4g7zhdCZFUJpc1Ovl7Ras7K56KYbBwrPgcTtWrl2sv204YpmILoOFahOi8qsBL6Csugjf
	 +dUk1ebS8Qq6hSdMSDXbvA9k20qQ9ys+u2Jui6NY3xb4eeuC0OH10ikxDI75xWXrYYDen
	 sey4ADo2ntKcvhNd567JYh+XryXSbmqySvZglHjNkVNo84wN3yiUBEPnjEkRVivdnwIyN
	 oWvE6ozmTOcnqipB/jV3Lbw6SBKXx97eF3z2xJNPOOA1j3z/YEAUyWdoELbXI6u9KmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795519643;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Et7sZ8dv2zeyM25guzv+Yh3/dpdKAKmHp9Nx1fkWc5c=;
	b=gEMlFzJV0011ani6QOTDHI6gxulpCLkIRcPvAMvWN8rIBVdQYodTPPGwWkQHvIz5M/CJ
	 gZistLlTxhfyXdCIO8FcRjdPtD/jQcJrQgY4RwtHQEO3iDg7w8AsyQHya/M5jCEKhTjdB
	 FzX9eoMJRcG4p9n7xhm8o3QrtpMSOFo2Ilhx/qesaaeKHfL8JFunAoEaXw2OWpst9qQIE
	 yPfgDG7Lies3Z4rbtMeu6PpaCkbHEkcNOadoe56d/LbxfaozHjt0w9dgU6UonrwM5wo3k
	 GGJE8XhMKvnjX8LuVXWAJSxnrQTOO+7aFHhNUElYslkwD8S3zuWkjLJtJ/ZiIScU3CA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HDYfBtZu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76584606A31E;
	Tue, 24 Nov 2026 11:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HDYfBtZu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91EFC1F000C0;
	Tue, 24 Nov 2026 11:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795519642;
	bh=Et7sZ8dv2zeyM25guzv+Yh3/dpdKAKmHp9Nx1fkWc5c=;
	h=From:To:Cc:Subject:Date;
	b=HDYfBtZub9CaSMaaqFArylWiUXUOoDX0cLljIODzKOyb0usLvdA+gjUhriD7a50QK
	 /JHSAwtR9xKc6qEevrT+XbQZEl9bLsyFHADbGJhg2WREIug0494kZizNRg9CXw5hmO
	 /Fn5VlyJGg+tRJy8Y4wSea8j/SUj3cflFM/4sBw9P9GztRcof78fv1UdoDk4ePIlH0
	 Y6G7oYHqeQFR34He6HnV0PAKou9b+3/hq54+ibbKYiVBLMXWmxHHMFGGozZZfbmUBx
	 8PHVEw29bi6skdRKo3XZwKxNZZDLNUgpdnw/ne58RuQILhsJEJ8So+4iwofoom9TXL
	 OsgZmYYy8cPHw==
From: =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>
To: Magnus Karlsson <magnus.karlsson@intel.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Alexander Duyck <alexanderduyck@fb.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Michael Chan <michael.chan@broadcom.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <shuah@kernel.org>,
	bpf@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Stuart Clark <stuclar@meta.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Simon Horman <horms@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Mina Almasry <almasrymina@google.com>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Randy Dunlap <rdunlap@infradead.org>,
	kernel-team@meta.com,
	Dimitri Daskalakis <dimitri.daskalakis1@gmail.com>,
	Bobby Eshleman <bobbyeshleman@meta.com>,
	Mohsin Bashir <mohsin.bashr@gmail.com>,
	Kees Cook <kees@kernel.org>,
	Breno Leitao <leitao@debian.org>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Tao Cui <cuitao@kylinos.cn>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	"Mike Marciniszyn (Meta)" <mike.marciniszyn@gmail.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Martin Karsten <mkarsten@uwaterloo.ca>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	David Wei <dw@davidwei.uk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	linux-rdma@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net-next 00/15] xsk: Receive in the device's buffer layout
Date: Tue, 24 Nov 2026 12:26:48 +0100
Message-ID: <20261124112707.118678-1-bjorn@kernel.org>
X-Mailer: git-send-email 2.56.1
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

AF_XDP zero copy makes the device fill one UMEM chunk per buffer, at
the UMEM headroom. Each driver carries a second RX path for this, and
bends its RX geometry to fit. Packets that the device would split over
several buffers, or pack several to a page, cannot be received without
a copy. fbnic and bnxt have no AF_XDP zero copy at all.

This series lets an AF_XDP socket receive in the layout that the
driver already uses for its page pool. The UMEM backs the page pools
of the bound queue through a memory provider, which the socket
installs with the queue management API, as devmem and io_uring zcrx
install theirs. The device places buffers in UMEM chunks as it places
them in pages: several buffers may share a chunk, a packet may span
chunks, and the device picks the offsets. The XDP program redirects
each packet to the socket through an XSKMAP, and each buffer becomes
one RX descriptor. A FILL entry lends a whole chunk, and an RX
descriptor with the new XDP_RX_CHUNK_FREE gives it back. This extends
the AF_XDP uAPI, see the documentation patch (15):

- XDP_UMEM_DRV_LAYOUT, a UMEM registration flag, selects the device's
  buffer layout: aligned PAGE_SIZE chunks, no headroom.
- XDP_RX_CHUNK_FREE, an RX descriptor option, gives a chunk back. An
  empty descriptor (len 0) at a chunk gives it back when the device
  let go of the chunk after its last buffer reached the socket.
- FILL lends whole chunks, and RX descriptors may point anywhere in a
  chunk.
- A bind in the device's buffer layout requires XDP_USE_NEED_WAKEUP
  and fails with EINVAL without it, as only the wakeup restarts a
  queue that ran out of buffers.
- The bind needs a native XDP program, one socket per queue receives,
  and XDP_COPY fails.

This series replaces "xsk: Zero copy through page-pool memory
providers" [1], see "The earlier series" below.

net_iovs stay unreadable
------------------------

For the core and the stack, UMEM chunks are net_iovs like any other.
netmem_address() and skb_frag_address() give NULL for them, every
net_iov frag still sets skb->unreadable, and page_pool_is_unreadable()
is true for every provider, as in mainline. The series marks no
provider readable and adds no readable capability.

Only XDP code reads the chunks, through an opt-in view (patch 1):

- A provider may give its net_iov area an XDP view: an address for
  each of its net_iovs. XDP code reads a net_iov only through
  xdp_netmem_address() and xdp_frag_address(), and only if its
  provider offers a view. The BPF helpers that read and write XDP
  buffers use them.

- Buffers with a view never become skb frags or xdp_frames. A reader
  that does not use the two helpers gets NULL, so it fails closed.

- dmabuf and io_uring zcrx offer no view, so nothing changes for them.

One check differs from mainline, and only for XDP-only providers
(patch 3): netif_rxq_has_unreadable_mp() leaves them out. Drivers use
it to turn on header split, but an XDP-only provider backs the headers
too, and with header split each packet would take more buffers.
page_pool_is_unreadable() is still true for such a provider, so bnxt
sets up its separate head pool for the queue. Page mode never
allocates from that pool, so it holds no pages.

The chunks are net_iovs and not pages because the UMEM is user memory,
pinned with GUP:

- mm owns the struct page fields that page_pool takes over: lru, where
  pp_magic and pp live, and mapping.
- A chunk larger than a page, in a follow-up, lies inside a hugetlb
  folio and is not a page of its own.
- The provider keeps state per chunk, in the net_iov.

io_uring zcrx wraps pinned user pages in net_iovs for the same
reasons.

Kernel structures stay out of UMEM
----------------------------------

Userspace may write the UMEM at any time, also while the kernel reads
it, so the kernel puts none of its own structures there:

- The shared info of a multi-buffer packet lives in one buffer per RX
  queue, in kernel memory (patch 2). XDP_FLAGS_SINFO_EXT selects it.
  Whoever prepares the buffer sets the flag before adding fragments.

- No xdp_frame and no skb is built in a provider buffer (patch 5).
  The buffers go only to the AF_XDP socket of their queue. The core
  turns XDP_TX and XDP_PASS into XDP_DROP. Later patches add both:
  the copy for XDP_PASS is in the full series, and XDP_TX from the
  buffer in place is later work, see Follow-ups. This series leaves
  them out to stay small. XDP_ABORTED and invalid verdicts reach the
  driver, which traces them and drops the packet. Frame conversion
  and skb construction refuse the buffers, so devmap and cpumap drop
  them.

- The kernel takes bounds only from its own fields, and only the program
  and its helpers read the bytes. A helper that checks bytes and reads
  them again must check a copy, as the syncookie helpers will, with a
  fix that goes to bpf separately.

Within these rules, XDP programs read and write the packet in place,
fragments included. A one-buffer packet is a normal linear buffer on
all three drivers, so programs without xdp.frags work.

How this extends memory providers
---------------------------------

The provider is a page_pool memory provider like devmem and io_uring
zcrx: alloc_netmems(), release_netmem(), init() and destroy(),
installed per queue with the queue management API, and uninstalled
when the socket unbinds or the device goes away. Drivers get zero copy
from their page pool path, the path that they use for the stack and
for XDP. They opt in with one page pool flag, take the address of an
XDP head with xdp_netmem_address(), and put heads back by netmem.
Driver code does not name AF_XDP.

The provider interface gains three things, each in its own patch:

- The XDP view (patch 1), see above.

- XDP-only providers (patch 3): MP_XDP_ONLY for a provider whose
  buffers go only to XDP. It backs every RX page pool of the queue,
  needs no header split, and native XDP may run next to it. A driver
  gets such memory only if it sets PP_FLAG_ALLOW_XDP_ONLY_NETMEM.

- hand_off() (patch 4): the last put of a net_iov that the provider
  marked goes to the provider instead of the pool cache, and the
  net_iov stays charged to the pool. AF_XDP gives a chunk back only
  once both the device and the socket are done with it.

The providers take page pool fragments: drivers split chunks as they
split pages, and the hand-off also covers the fragment allocator.

Most of the size is AF_XDP's own contract, not provider plumbing:
chunk ownership through FILL, refill, delivery, give-back and
teardown, in net/xdp/xsk_sink.c.

Code size
---------

The series adds 1793 lines and removes 139:

  net/xdp/xsk_sink.[ch]     +793       (185 of them comments, 99
                                        blank; 26 functions)
  rest of AF_XDP            +139/-20   (xsk.c, xsk_buff_pool.c,
                                        xdp_umem.c, headers)
  XDP core, BPF helpers     +228/-13   (xdp.h, xdp.c, netmem.h,
                                        filter.c)
  page_pool, providers      +110/-14
  netdev core                +56/-3    (dev.c, netdevice.h,
                                        ethtool rings.c)
  uAPI                       +30       (if_xdp.h and its tools copy)
  fbnic                      +34/-17   (15 of the added for
                                        XDP_REDIRECT, which fbnic
                                        lacked)
  mlx5                       +17/-7
  bnxt                       +23/-37
  selftests                 +250/-27
  documentation             +113/-1

The sink takes no lock on delivery, as only the queue NAPI writes to
the RX ring, and a queue restart stops the old NAPI before the new one
runs.

Classic zero copy is a separate RX and TX path in each driver:
ice_xsk.c has 956 lines, mlx5's en/xsk/ 1019 (plus hooks in the rest
of the driver), i40e_xsk.c 807, ixgbe_xsk.c 566, and idpf's xsk.c 641
(plus 272 in libeth).

We also wrote classic zero copy for fbnic, without this series. The
first version added 1239 lines to fbnic and removed 163. A trimmed
version adds 565 and removes 97 (TX is +156/-28 of that), plus 32
lines in xdp_sock_drv.h. This series changes fbnic by +19/-16 for RX,
plus +15/-1 for XDP_REDIRECT, which classic zero copy needs too.
Zero-copy TX, a follow-up, adds +65/-3 to fbnic. On the same host, on
another day, the trimmed classic driver received 28.3 Mpps at 66
bytes; this series receives 27.6 Mpps, and 31.4 Mpps with the speed
follow-ups.

The follow-ups, 26 patches in the full series, see Follow-ups:

  xskxceiver timeout, 1         +29/-3
  speed, 4 patches             +154/-22   core only
  XDP_PASS copy, 3             +157/-16   bnxt +56/-2 of it
  zero-copy TX, 6              +555/-57   fbnic +65/-3, mlx5 +126/-6,
                                          bnxt +100/-2
  bnxt TX batching, 2           +38/-11
  larger chunks, 5             +167/-84   fbnic +21/-6, mlx5 +12/-5,
                                          bnxt +23/-15
  mlx5 performance, 4          +121/-22
  bnxt RX loop, 1               +13/-3

Unlike RX, TX needs code in each driver: the driver turns the
socket's TX descriptors into device descriptors and completes them.

Generic pieces, and who else gains
----------------------------------

Patches 1-4 and 11 name no AF_XDP:

- Patch 1, the XDP view, works for any provider. io_uring zcrx, for
  example, could let XDP read its memory, while the stack keeps
  treating it as unreadable.

- Patch 2, shared info in kernel memory, works for any buffer.
  Classic zero copy keeps the shared info of a multi-buffer packet in
  the tail of the head's UMEM frame today, where userspace can change
  it while the kernel walks the fragments. It can move it out of UMEM
  with this flag, in a separate series. Buffers with the flag may also
  use the 320 bytes that the shared info took. No driver in this
  series packs its buffers tighter for that yet.

- Patches 3 and 11 serve any XDP-only provider, and patch 4 any
  provider that needs the last put of a net_iov.

Driver changes that help other users:

- fbnic supports XDP_REDIRECT (patch 9). Any native XDP program on
  fbnic can redirect to devmap, to cpumap and to AF_XDP sockets in
  copy mode. Before, the verdict was invalid and dropped the packet.

- mlx5 restarts a queue with an XDP program attached (patch 12), for
  any user of the queue management API. In the tree today only memory
  providers restart queues, and all but XDP-only ones refuse XDP, so
  nobody else gains yet.

- In the follow-ups, bnxt reports the VLAN tag of XDP buffers to any
  XDP program, and its inlined RX loop makes native XDP_DROP 3.6 %
  faster. Classic zero-copy TX counts its completions in the kernel,
  so userspace that writes the completion producer cannot change the
  kernel's count of descriptors in flight. The high-order
  page patches for mlx5, fbnic and bnxt work for any provider, but
  XDP-only ones are their only users in the tree today.

The bnxt fixes below help today's users, every busy-poll user and every
queue restart with XDP attached, and a separate syncookie fix for bpf
protects XDP programs on classic zero-copy queues.

Why a second zero-copy model
----------------------------

Classic zero copy hands the driver one UMEM chunk per RX buffer. The
driver fills it at the UMEM headroom, through an AF_XDP RX path of its
own: ice, i40e, idpf and others have one, and mlx5 has a separate XSK
RQ for it. The buffer size is the chunk size, so the driver cannot
pack several packets into a page or split one packet the way it does
for the stack. Teaching classic zero copy the device's layout would
mean rewriting that RX path in every driver, and changing what a
descriptor owns.

Here the device keeps its own layout, and the driver keeps its own RX
path. Ownership moves from the buffer to the chunk: FILL lends a
chunk, and the kernel gives it back with XDP_RX_CHUNK_FREE.

The two models serve different users. With classic zero copy, the
application decides where each frame lands, one frame per chunk at a
headroom it picks, or at any address with unaligned chunks. Applications
that need that control keep it, and each driver pays for it with an
AF_XDP RX path of its own. With the device's layout, the application
gives up that control. The device decides where packets land and how
many share a chunk, and the driver needs a few dozen lines on top of its
existing RX path.

Classic zero copy stays as it is. A UMEM chooses the model when it is
registered, with XDP_UMEM_DRV_LAYOUT, and nothing changes for UMEMs
without the flag or for drivers with classic zero copy. Both models
share the rings, the descriptors and the XSKMAP, and zero-copy TX in
the device's layout, a follow-up, reuses the classic TX helpers.

On mlx5, which has both, classic zero copy is faster at MTU 1500:
24.5 Mpps at 66 bytes against 16.4 Mpps for this series, and 20.7
Mpps with the follow-ups, see Performance. With 16 KiB chunks, a
follow-up, the device's layout passes it (25.9 Mpps). At MTU 5000,
classic zero copy cannot bind, as the XSK RQ needs a linear RQ and has
no multi-buffer. This series receives multi-buffer packets at any
MTU.

uAPI
----

- XDP_UMEM_DRV_LAYOUT, a UMEM flag: aligned PAGE_SIZE chunks, no
  headroom. Binding needs a native XDP program, attached through
  netlink, and the program cannot be detached while the UMEM backs
  the queue. That ends when the receiving socket closes, even if a
  TX-only socket stays bound. One socket per queue receives; a second
  socket with an RX ring gets -EBUSY. Sockets that share the UMEM may
  transmit, in copy mode. XDP_COPY fails.

- A bind in the device's buffer layout requires XDP_USE_NEED_WAKEUP
  and fails with EINVAL without it. The drivers do not poll FILL: once
  FILL ran dry and the device used its posted buffers, only the wakeup
  from recvmsg() or poll() restarts the queue.
  The kernel also asks for a wakeup while chunks wait for room in the
  RX ring, as only the queue NAPI gives them back.

- FILL lends whole chunks.

- RX descriptors point at the buffers that the device filled.
  XDP_PKT_CONTD chains the buffers of a packet. Metadata that the
  program wrote is in front of the first buffer.

- XDP_RX_CHUNK_FREE, a descriptor option: the kernel is done with the
  chunk of the descriptor, and the chunk is the application's again.
  If the device lets go of a chunk after its last buffer reached the
  socket, an empty descriptor (len 0) at the chunk carries the flag.

Ownership stays per chunk, as in classic AF_XDP. The application
never returns single buffers, and a chunk that it got back can go on
the TX ring. A held packet keeps its whole chunk.

Patches
-------

1     xdp: the XDP view of net_iovs, and the helpers that use it.
2     xdp: the shared info of a buffer in kernel memory.
3     XDP-only memory providers.
4     page_pool: hand_off() for the last put of a marked net_iov.
5     xdp: programs on buffers that must not hold kernel structures.
6     xsk: chunks lent to the page pools of a queue.
7     xsk: delivery to the socket, and chunks given back.
8     xsk: the uAPI. Nothing in 6 and 7 is reachable before this
      patch.
9-10  fbnic: XDP_REDIRECT, then RX.
11    netif_rxq_has_xdp_only_mp(), for drivers that lay out a queue
      before they create its page pools.
12-13 mlx5, bnxt.
14    A mode for xskxceiver.
15    Documentation.

Performance
-----------

Machines, one per NIC, all of one platform type:

  CPU       AMD EPYC 9D64, 88 cores, one socket, SMT on, DDR5-4800.
            The test core ran at 2.95 GHz; acpi-cpufreq, performance
            governor, boost on.
  Kernel    mitigations=off, iommu=pt.
  fbnic     Meta fbnic, firmware 26.01.07-006, 50 Gb/s, PCIe 4.0 x4.
  mlx5      NVIDIA ConnectX-7 (MT2910), firmware 28.48.1000,
            50 Gb/s, PCIe 4.0 x4.
  bnxt      Broadcom BCM57504, firmware 232.0.159.4 (package
            232.1.136.4), 50 Gb/s, PCIe 4.0 x4.

Traffic comes from a second machine of the same type with
xdp-trafficgen. One UDP flow lands on the measured queue.

One RX queue. The application, its NAPI and the IRQ share one core,
with preferred busy polling (socket timeout 100 us, budget 256, batch
256). The UMEM has 16,384 chunks. The program redirects through an
XSKMAP. Mpps and cycles per packet on that core, 66-byte frames,
medians over two rounds of alternating boots:

               XDP_DROP     AF_XDP, busy poll   AF_XDP, epoll
  fbnic        38.8  (76)   27.6 (106)          26.6
  mlx5         31.6  (93)   16.4 (179)          16.2
  bnxt [2]     24.3         18.1 (162)          17.9

XDP_DROP is native XDP on the same kernel, without a provider. The
rows ran on builds of this series on an older base. The sink has
since lost its reserve stack and backlog; A/B
runs of that change measured level on all three NICs, with equal or
fewer instructions per packet. At MTU 1500, mlx5 puts one packet in
each 4 KiB chunk, as its strides keep room for the shared info of an
skb, so every packet costs a FILL entry, a refill and a give-back.

On mlx5, classic zero copy through the XSK RQ receives 24.5 Mpps
(120) on the same host.

fbnic, bnxt and mlx5 run at line rate with 9000-byte frames, which XDP
multi-buffer receives as three 4 KiB chunks. The UMEM must hold more
chunks than the queue keeps posted: at MTU 9000, mlx5 posts four pages
per RX ring entry, up to 16,384 pages, so the 9000-byte runs used 65,536
chunks against 16,384 elsewhere.

[2] With "eth: bnxt: Ring the NQ doorbell during busy poll" and "eth:
    bnxt: Do not reset TX queue 0 BQL for XDP rings", see
    Dependencies.

Programs that use no provider see no measurable change in packet rate
with native XDP_DROP, as the variation stays within the 3 % that code
layout alone causes. The series adds about 6 instructions per packet on
fbnic, and under 3 on mlx5 and bnxt, for the net_iov test in
xdp_netmem_address() and the static key of the sink verdict.

What the follow-ups do to the AF_XDP busy-poll test above, measured
one part at a time on top of this series, as a share of native
XDP_DROP on the same kernel:

                                fbnic          mlx5          bnxt
  this series                   27.6 (71 %)    16.4 (52 %)   18.0 (73 %)
  + speed                       31.4 (83 %)    16.7 (53 %)   18.9 (77 %)
  + mlx5 performance            -              20.8 (67 %)   -
  whole series, 4 KiB chunks    31.0 (85 %)    20.7 (68 %)   18.6 (76 %)
  whole series, 16 KiB chunks   35.9 (99 %)    25.9 (86 %)   20.6 (83 %)
  whole series, 32 KiB chunks   -              -             21.0 (85 %)
  whole series, 128 KiB chunks  37.4 (103 %)   27.1 (90 %)   -

The XDP_PASS copy and TX do not change the redirect path. Larger chunks
need huge-page UMEM. With 16 KiB chunks and more, fbnic receives into an
AF_XDP socket at the rate of native XDP_DROP. On bnxt the sink stays
about 18 cycles per packet above native: native XDP_DROP reuses the RX
buffer in place, and the sink takes a new buffer for every packet.

At MTU 5000, with the follow-ups and 16 KiB chunks, on one RX queue,
medians over two boots. At 300, 1500 and 5000 bytes, cycles per
packet on interrupts; at 66 bytes, Mpps with busy poll:

                         300 B   1500 B   5000 B    66 B
  fbnic  AF_XDP            354      322      565    35.9
         XDP_DROP          204      184      447    36.8
  mlx5   AF_XDP            323      374      418    22.9
         XDP_DROP          165      211      381    36.6
  bnxt   AF_XDP            380      336      802    20.5
         XDP_DROP          116      197      534    26.2

At 1500 and 5000 bytes both receive at line rate, so the table gives
the work per packet of the receiving core, with RX interrupt
coalescing of 33 us or 88 frames. That cost depends on the
coalescing, and with busy poll the core spins whatever the rate. At
300 bytes the AF_XDP column counts two cores, NAPI and the
application. fbnic ran on another pair of machines, with firmware
25.08.05-004 and an AF_XDP generator in copy mode.

With 4 KiB chunks at this MTU, mlx5 keeps a nonlinear RQ and costs 700
cycles at 5000 bytes, as does this series alone (699). Classic mlx5
zero copy cannot bind at MTU 5000.

Zero-copy TX, a follow-up, at 66 bytes on one core: fbnic 35.3 Mpps,
mlx5 29.5, bnxt 35.8, against 1.0 to 2.4 Mpps in copy mode.

Dependencies
------------

These fixes go separately:

- "eth: bnxt: Ring the NQ doorbell during busy poll", for net.
  Without it, a busy-polled bnxt queue stalls.

- "eth: bnxt: Do not reset TX queue 0 BQL for XDP rings", for net.
  With TPH, every RX queue restart with XDP attached resets BQL of TX
  queue 0, and the next completion there hits the BUG in
  dql_completed(). Binding and unbinding an AF_XDP socket in this
  mode restarts the queue with XDP attached.

Follow-ups
----------

The full series, 42 patches with the syncookie fix, is at
https://github.com/fb-bjorn/linux/tree/xsk-device-v1. Each part
comes with its own numbers, see Performance.

- Speed: a kfunc that redirects to the queue's socket without an
  XSKMAP, batched reference drops, a path for one-buffer packets, and
  a prefetch of FILL chunks.

- XDP_PASS: the stack gets a copy instead of a drop. bnxt first
  reports the VLAN tag of XDP buffers, and offers XDP-only providers
  only in legacy eswitch mode, as the copy would otherwise reach the
  PF instead of the representor.

- Zero-copy TX in the device's buffer layout for fbnic, mlx5 and bnxt,
  with no uAPI change, and one completion per TX batch on bnxt.

- Larger chunks: 16 KiB to 128 KiB chunks in huge pages, through the
  rx_page_size of the queue.

- mlx5: keep XDP-only RQs linear above a page-sized MTU, so that
  larger chunks hold several packets at MTU 5000, flush redirects
  after reposting WQEs, let go of a page after its last stride, and
  skip head prefetches.

- bnxt: inline RX packets into the completion loop.

Later work, not in the full series:

- Small MTUs on mlx5: leave the shared info out of the strides of
  XDP-only RQs, two packets per 4 KiB chunk at MTU 1500. It takes this
  series from 16.4 to 19.6 Mpps on mlx5, but cannot act above MTU
  1770.

- XDP_TX for these buffers, sent from the buffer in place.

- Classic zero copy with its shared info in kernel memory, with the
  flag from patch 2.

The earlier series
------------------

"[PATCH net-next v1 00/11] xsk: Zero copy through page-pool memory
providers" [1], posted on 10 Nov 2026, kept the application's buffer
layout, one UMEM chunk per buffer at the UMEM headroom, behind a
memory provider that the core could read. This series is new rather
than a version of it, and answers the review there:

- The device's buffer layout instead of the application's. The device
  places buffers in chunks as it places them in pages, and ownership
  moves from the buffer to the chunk.

- Providers stay unreadable to the core and the stack. There is no
  readable capability: XDP alone reads provider memory, through an
  opt-in view. The providers take page pool fragments.

- Smaller driver changes, and no AF_XDP code in drivers. The earlier
  series changed 651 lines of fbnic, its only driver. This one changes
  51 lines of fbnic, 24 of mlx5 and 60 of bnxt for RX.

Open questions
--------------

- Shared info outside the buffer: one per RX queue behind a flag, as
  here, or a pointer in struct xdp_buff that classic zero copy can
  use as well?

- Provider buffers are told by their address in xdp_prepare_buff(),
  with one range check under a static key. Is that fine, or should
  drivers mark them?

- MAINTAINERS needs an entry for net/xdp/xsk_sink.c.

[1] https://lore.kernel.org/netdev/20261110102039.1002605-1-bjorn@kernel.org/

Björn Töpel (15):
  xdp: Let memory providers offer XDP a view of their net_iovs
  xdp: Keep the shared info of a buffer in kernel memory
  net: Add memory providers that only feed XDP
  page_pool: Let memory providers take back net_iovs
  xdp: Run programs on buffers that must not hold kernel structures
  xsk: Lend UMEM chunks to the page pools of a queue
  xsk: Deliver to the socket in the device's buffer layout
  xsk: Receive in the device's buffer layout
  eth: fbnic: Support XDP redirect
  eth: fbnic: Receive into XDP-only memory providers
  net: Add netif_rxq_has_xdp_only_mp()
  eth: mlx5e: Receive into XDP-only memory providers
  eth: bnxt: Receive into XDP-only memory providers
  selftests: net: xsk: Test the device's RX buffer layout
  Documentation: networking: Describe AF_XDP RX in the device's layout

 Documentation/networking/af_xdp.rst           | 114 ++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  39 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c |  19 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  14 +-
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |  10 +-
 .../net/ethernet/meta/fbnic/fbnic_netdev.c    |   3 +-
 drivers/net/ethernet/meta/fbnic/fbnic_txrx.c  |  45 +-
 drivers/net/ethernet/meta/fbnic/fbnic_txrx.h  |   3 +
 include/linux/netdevice.h                     |   3 +
 include/net/netdev_queues.h                   |   1 +
 include/net/netmem.h                          |  21 +-
 include/net/page_pool/memory_provider.h       |  21 +
 include/net/page_pool/types.h                 |  15 +-
 include/net/xdp.h                             | 131 ++-
 include/net/xdp_sock.h                        |   8 +
 include/net/xsk_buff_pool.h                   |   3 +
 include/uapi/linux/if_xdp.h                   |  15 +
 net/core/dev.c                                |  51 +-
 net/core/filter.c                             |  17 +-
 net/core/netdev_rx_queue.c                    |  51 +-
 net/core/page_pool.c                          |  36 +-
 net/core/xdp.c                                |  72 +-
 net/ethtool/rings.c                           |   5 +-
 net/xdp/Kconfig                               |   1 +
 net/xdp/Makefile                              |   2 +-
 net/xdp/xdp_umem.c                            |   5 +
 net/xdp/xsk.c                                 | 110 ++-
 net/xdp/xsk_buff_pool.c                       |  30 +-
 net/xdp/xsk_sink.c                            | 773 ++++++++++++++++++
 net/xdp/xsk_sink.h                            |  20 +
 tools/include/uapi/linux/if_xdp.h             |  15 +
 .../testing/selftests/net/lib/xsk/test_xsk.c  | 248 +++++-
 .../testing/selftests/net/lib/xsk/test_xsk.h  |   4 +
 .../selftests/net/lib/xsk/xskxceiver.c        |  25 +-
 35 files changed, 1793 insertions(+), 139 deletions(-)
 create mode 100644 net/xdp/xsk_sink.c
 create mode 100644 net/xdp/xsk_sink.h


base-commit: 57f165ff2f30491bc3511d24a52ca516751a268b
-- 
2.56.1
