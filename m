Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795525204;
	b=xsd5cjfTxbqp50lPooXiXYlLFJwMbHP5Jv8vhrt2uXvfw+l9K0bc5o4k8alG4LcLeFar
	 9VmTH/ZkaS8RomDCKn9OIt8OhawSv7qJZI6UqQm1h4W440X2WmW8+d5sHmWOfzVZSwgDc
	 9eQxwPq1MNFSv1SfXyKOOPG9P5ttihKgBkSsoHdhITMvUFX4X5aev8bkq/alrYfF+t21S
	 +qm2ogZ0gQOx6xXioGpC3IVJXCvx083aXSeA5P2Y9eAjQx6L32jHCnTjdosgktTUEXRK+
	 DgGUdWB0EpW1I0vVoNdREx49b0jDDz8PbpJM8ybyDhqTE+mhtM4gVDwn6BjuktsQtqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795525204;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=71BoVSHnE+GD+Dgl6FXGb+jcMgjjSfPvCEpcdkQChEA=;
	b=HF21hN101rY8uVx+ZGk+DxpY50TADwheJrb+opcEj1Cr6/mUBNWwf632xYmT7ZkIS2Dx
	 I80X4ulEVlsZqN0xscBlV1aWZPIY7SmO1psQ7D1Idful32gD3ZWjXWV56B9BnsweGFBqG
	 lmCxzv62FnF5G1y9kGoqh4hJPtqVotbt1M/7WA6kl/7bdnYijS+RUDWjJfHwRxbOfD8ey
	 SEs+NUnuLhLItjb2vXqw7JoX5Qd6+avZnlfn4x7MmdVDZjziRCFEC0T1rbLG2idy7KkuJ
	 7LlivEtY+hidPhxO7pT7LzCBsi16eP0pWqclsXN0PW8XO1pDQcnNqe5Bm/w2elwCoEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E86WLCWj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0EA8606A322;
	Tue, 24 Nov 2026 13:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E86WLCWj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B07E1F000EB;
	Tue, 24 Nov 2026 12:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795525203;
	bh=71BoVSHnE+GD+Dgl6FXGb+jcMgjjSfPvCEpcdkQChEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E86WLCWjW/dY4qNrjCcvSgN4bRHl901N+otwhHt70E0TMaHKYQSW5I7hgi+LAGxfq
	 ZxNXgrh4lDpc6FDf/Ynrj5beVp71XcI3kUJbPuyDC4L1kF+VdDMWhEaviqH8TeWdtT
	 ui4VnFe4H8joiI1mUVh/PJymfuXR6hUdk5HyA07d5ojk+4UV+16icOSL07RlUFMNZ0
	 mx536iKYMFFus57c2465mz+u5d3TSknYeFbxhIdG1UalTGK8RID02MDxV8BE3BBhWD
	 TKo/PI5cNDXZUzeAxaaPYg1+VuMIHiTA9Wvzf9HoyVw45e9tab4/NjtsVR9P9euQQi
	 GyQNqx6hdrYeA==
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
Subject: [PATCH net-next 15/15] Documentation: networking: Describe AF_XDP RX in the device's layout
Date: Tue, 24 Nov 2026 13:56:50 +0100
Message-ID: <20261124125654.183091-15-bjorn@kernel.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261124112707.118678-1-bjorn@kernel.org>
References: <20261124112707.118678-1-bjorn@kernel.org>
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

For applications, XDP_UMEM_DRV_LAYOUT changes who owns a chunk and
when, what the XDP program may read and write, which verdicts it may
return, and how chunks come back. None of it is documented yet.

Describe for application writers the setup and its errors, the
program, receiving and giving chunks back, need_wakeup, devices that
need DMA syncs, and how TX shares the chunks.

Signed-off-by: Björn Töpel <bjorn@kernel.org>
---
 Documentation/networking/af_xdp.rst | 114 +++++++++++++++++++++++++++-
 1 file changed, 113 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/af_xdp.rst b/Documentation/networking/af_xdp.rst
index 538e71adb759..4e37a6074a52 100644
--- a/Documentation/networking/af_xdp.rst
+++ b/Documentation/networking/af_xdp.rst
@@ -429,7 +429,9 @@ There is also an option to set the headroom of each single buffer in
 the UMEM. If you set this to N bytes, it means that the packet will
 start N bytes into the buffer leaving the first N bytes for the
 application to use. The final option is the flags field, but it will
-be dealt with in separate sections for each UMEM flag.
+be dealt with in separate sections for each UMEM flag. With the
+XDP_UMEM_DRV_LAYOUT flag, chunks are pages that the device fills in
+its own layout, see the "Device Buffer Layout" section.
 
 SO_BINDTODEVICE setsockopt
 --------------------------
@@ -761,6 +763,116 @@ processing. Note that the Tx batch API guarantees that it will provide
 a batch of Tx descriptors that ends with full packet at the end. This
 to facilitate extending a zero-copy driver with multi-buffer support.
 
+Device Buffer Layout
+====================
+
+In zero-copy mode, the driver fills one UMEM frame per buffer, at the
+UMEM headroom, and needs a receive path of its own for AF_XDP. With
+the XDP_UMEM_DRV_LAYOUT UMEM flag, the device places buffers in UMEM
+chunks as it places them in the pages of its page pool: several
+buffers may share a chunk, a packet may span chunks, and the device
+picks the offsets. The XDP program reads and writes packets in place,
+in the UMEM, but the kernel stores none of its own structures in the
+chunks.
+
+The UMEM backs the page pools of the bound queue through a memory
+provider, so the driver needs no AF_XDP code. A driver supports the
+mode if it runs native XDP with XDP_REDIRECT, takes its receive
+buffers from a page pool of netmem that allows such providers, and
+can restart a queue.
+
+Setting up
+----------
+
+* Register the UMEM with XDP_UMEM_DRV_LAYOUT, aligned chunks of
+  PAGE_SIZE, and no headroom. The UMEM must hold more chunks than the
+  queue keeps posted to the device and in its page pool cache, 128
+  chunks with 4K pages, or the bind fails with ENOSPC. The first
+  number depends on the driver, the ring size and the MTU.
+
+* Attach a native XDP program to the device itself through netlink,
+  not through a BPF link or an upper device such as a bond, before the
+  bind. The bind fails with ENOENT without one. The program cannot be
+  detached while the UMEM backs the queue (EBUSY).
+
+* Put chunks on the FILL ring before the bind. The bind starts the
+  queue with the chunks it finds there, and the queue drops packets
+  while it has none.
+
+* Bind with XDP_USE_NEED_WAKEUP, as only a wakeup restarts a queue
+  that used up the FILL ring, and with XDP_USE_SG to receive packets
+  that span chunks. A bind without XDP_USE_NEED_WAKEUP fails with
+  EINVAL. XDP_COPY fails with EOPNOTSUPP, as does a device
+  without native XDP_REDIRECT or queue management. One socket per
+  queue receives: a second socket with an RX ring gets EBUSY, and so
+  does any socket with an RX ring once the receiving socket is gone.
+  Sockets that share the UMEM with XDP_SHARED_UMEM may transmit.
+
+The XDP program
+---------------
+
+The program works on the packet in place, in the UMEM: direct packet
+access, bpf_xdp_load_bytes(), bpf_xdp_store_bytes(), dynptrs,
+bpf_xdp_adjust_head(), bpf_xdp_adjust_tail(), bpf_xdp_adjust_meta()
+and the RX metadata kfuncs work as with pages, on every buffer of the
+packet. What the program writes is in the UMEM for the application to
+see. The kernel keeps its own data, such as the fragment list of a
+packet that spans buffers, in kernel memory, so the application cannot
+change what the kernel relies on. The application may still change
+the packet at any time, also while the program runs: two reads of the
+same bytes may differ.
+
+Buffers of the bound queue may only go to its receiving socket. Every
+verdict but XDP_REDIRECT drops the packet, XDP_PASS included, and
+redirects to anything but the receiving socket fail.
+
+Redirect through an XSKMAP entry that holds the receiving socket.
+
+Receiving
+---------
+
+A FILL entry lends a whole chunk to the kernel, by its address. Each
+buffer of a packet becomes one RX descriptor that points at the data,
+anywhere in a chunk, and XDP_PKT_CONTD chains the buffers of a packet
+as described in the multi-buffer section. Metadata that the program
+wrote is in front of the first buffer, where the program put it; a
+packet whose metadata does not fit in front of its first buffer, in
+the same chunk, is dropped.
+
+The kernel gives a chunk back with XDP_RX_CHUNK_FREE in the options of
+an RX descriptor:
+
+* On a descriptor with data, the flag means that the kernel is done
+  with the chunk of that descriptor. The application owns the whole
+  chunk again.
+
+* A descriptor with length zero, at the address of a chunk, only gives
+  that chunk back. The kernel posts one when the device let go of the
+  chunk after its last buffer reached the socket. Such a descriptor is
+  never part of a packet.
+
+A chunk may go on the FILL ring again once it came back and the
+application is done with all its buffers. The kernel never gives back
+single buffers, so a packet that the application holds keeps its
+chunk. Chunks whose buffers all stayed in the kernel, as for dropped
+packets, stay lent.
+
+The kernel asks for a wakeup on the FILL ring only while it has run
+out of FILL entries; recvmsg() or poll() then restarts the queue. With
+preferred busy polling, the application's poll runs the queue's NAPI.
+
+Devices that need DMA syncs work as they do with page pools: the
+kernel syncs a chunk for the device when the FILL ring lends it, and
+the driver syncs each buffer for the CPU before the program runs.
+
+Transmitting
+------------
+
+Sockets in this mode transmit in copy mode. A buffer that the
+application received may go on the TX ring. Its chunk may go on the
+FILL ring only once the chunk came back and every TX descriptor that
+points into it is on the COMPLETION ring.
+
 Sample application
 ==================
 There is a xdpsock benchmarking/test application that can be found at
-- 
2.56.1

