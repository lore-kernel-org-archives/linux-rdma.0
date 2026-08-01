Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADEDF37996C
	for <linux-rdma@vger.kernel.org>; Sat,  1 Aug 2026 09:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785576492; cv=none; b=FvE9z6+H0xeC9M3dZ0QCSHm36+8LBTZMIh189hEu/6jGOAWEg/rNd7L62Han0RoBFErKAykFGGBq54M6PP6EwzmflFw3+HvaPcVA/5g6+ekZcZ/fPYINl2lUAQfkk4HJEfOoSIlssi6dzsIBYP3J+mPO1zYmAQ1SvXbAWEwENY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785576492; c=relaxed/simple;
	bh=zEQD7jMNVY6b9k3ZRFvVx3bY3shqZgC9FPltR26YjlE=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc:
	 In-Reply-To:References; b=cKU2ydtPlwEQGzDmwmg/JeyBsTlzc028Eko9yakQYf9V9iihW3vx6lLLocOFl3nyCMIKfQkdH+nVmk2EjWjIFoZAx9JZweaFOAFnKfI2NsHyO01GGW4FEwQU4812wgbXUXpG+eDzHjr3GEF+1g9777lOQsPsAmaF7xXwR3b8uWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DNwNNZWR; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DNwNNZWR"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785576484;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=A8EFahKHpEAa65jHZyl5Uw2yJExo1ncIBHHZKuRiVzQ=;
	b=DNwNNZWR0TNBjBIDlG6NvTCF3hrlYX/sdh2B11W7WLbYQkf5Yhm5DgVFY7uynaeKuTZDry
	WGKj4PUUHbvt6vnvXoG1HlRkgTQat0+MM7I2JAb0s+fyw4Mrm5um4JWJGK5MZR8eRo2A82
	4CdwJoD8XDBLB42a0McN9bGfCSacUBA=
Date: Sat, 01 Aug 2026 09:27:51 +0000
Content-Type: multipart/mixed;
 boundary="892d20c4-f315-4a33-b425-f22d7dab38b0-1"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: gang.yan@linux.dev
Message-ID: <f83663d533bec05c77d12b234dd10fde851bf81a@linux.dev>
TLS-Required: No
Subject: Re: [PATCH net 0/2] RDMA/rxe: fix mr_check_range() iova overflow
 (OOB)
To: "Zhu Yanjun" <yanjun.zhu@linux.dev>, zyjzyj2000@gmail.com
Cc: linux-rdma@vger.kernel.org, "Gang Yan" <yangang@kylinos.cn>
In-Reply-To: <f60cfa62-8fe3-410d-a12d-24ebd22a79fd@linux.dev>
References: <20260728091128.9116-1-gang.yan@linux.dev>
 <f60cfa62-8fe3-410d-a12d-24ebd22a79fd@linux.dev>
X-Migadu-Flow: FLOW_OUT

--892d20c4-f315-4a33-b425-f22d7dab38b0-1
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

July 30, 2026 at 1:15 PM, "Zhu Yanjun" <yanjun.zhu@linux.dev mailto:yanju=
n.zhu@linux.dev?to=3D%22Zhu%20Yanjun%22%20%3Cyanjun.zhu%40linux.dev%3E > =
wrote:


>=20
>=20=E5=9C=A8 2026/7/28 2:11, Gang Yan =E5=86=99=E9=81=93:
>=20
>=20>=20
>=20> From: Gang Yan <yangang@kylinos.cn>
> >=20
>=20>  Hi, Maintainers
> >=20
>=20>  I've recently started learning RDMA, using soft-RoCE (rxe) as my s=
tudy
> >  platform. While pair-programming with an AI assistant during this le=
arning,
> >  it flagged an integer overflow in mr_check_range(). I dug in, stood =
up a
> >  small reproducer, and -- believing the issue is real and worth fixin=
g --
> >  put together this small series.
> >=20
>=20Do you have a small reproducer for this issue? If so, could you pleas=
e share it on the RDMA mailing list?

Hi,

Thanks for your review. Here is a small reproducer (attached rxe_overflow=
_repro.c). I put it together
quickly with the help of an Claude Code, as I'm still quite new to RDMA.

Idea: the client posts
the client posts one RDMA-Write whose remote_addr
  (0xfffffffffffffff8, len 8) makes iova + length wrap to 0, bypassing th=
e
  old mr_check_range() comparison; the responder then derives an
  out-of-bounds page index in rxe_mr_iova_to_index() (the WARN_ON) and
  reaches mr->page_info[] OOB.

Build & run (as root):

 sudo yum install -y libibverbs-devel librdmacm-devel
 gcc -O2 -o repro rxe_overflow_repro.c -libverbs -lrdmacm
 sudo modprobe rdma_rxe
 sudo ip link add dummy0 type dummy
 sudo ip addr add 192.168.172.1/24 dev dummy0 && sudo ip link set dummy0 =
up
 sudo ip link set dummy0 up
 sudo rdma link add rxe0 type rxe netdev dummy0
 sudo ./repro 192.168.172.1

and then check the dmesg:
[  136.830844] ------------[ cut here ]------------
[  136.830848] WARNING: drivers/infiniband/sw/rxe/rxe_mr.c:99 at rxe_mr_i=
ova_to_index+0x78/0x90 [rdma_rxe], CPU#188: kworker/u957:0/1368
[  136.830870] Modules linked in: rdma_ucm ib_uverbs ib_uverbs_support rd=
ma_cm iw_cm ib_cm dummy rdma_rxe ib_core ip6_udp_tunnel udp_tunnel joydev=
 uinput snd_seq_dummy snd_hrtimer rfkill nf_conntrack_netbios_ns nf_connt=
rack_broadcast nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_=
inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct nft_chain_nat nf_nat=
 nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nf_tables sunrpc qrtr snd_hda=
_codec_generic snd_hda_intel snd_hda_codec snd_hda_core snd_intel_dspcfg =
snd_intel_sdw_acpi snd_hwdep intel_rapl_msr snd_seq intel_rapl_common snd=
_seq_device snd_pcm virtio_balloon snd_timer snd i2c_piix4 soundcore pcsp=
kr i2c_smbus zram lz4hc_compress vmw_vsock_virtio_transport vmw_vsock_vir=
tio_transport_common vsock qxl serio_raw drm_exec drm_ttm_helper e1000 tt=
m ata_generic pata_acpi i2c_dev qemu_fw_cfg virtiofs fuse
[  136.830928] CPU: 188 UID: 0 PID: 1368 Comm: kworker/u957:0 Not tainted=
 7.2.0-rc5+ #1 PREEMPT(lazy)
[  136.830931] Hardware name: Red Hat KVM, BIOS rel-1.16.3-0-ga6ed6b701f0=
a-prebuilt.qemu.org 04/01/2014
[  136.830935] Workqueue: rxe_wq do_work [rdma_rxe]
[  136.830944] RIP: 0010:rxe_mr_iova_to_index+0x78/0x90 [rdma_rxe]
[  136.830953] Code: 48 83 c4 28 e9 f9 1d 79 d2 48 8b 4f 68 48 23 8f 48 0=
1 00 00 48 29 c8 48 89 c2 48 c1 ea 0c 48 63 c2 41 3b 90 58 01 00 00 72 d6=
 <0f> 0b 48 83 c4 28 e9 cd 1d 79 d2 66 90 66 66 2e 0f 1f 84 00 00 00
[  136.830954] RSP: 0018:ffffd0c5833c7d38 EFLAGS: 00010286
[  136.830957] RAX: ffffffffffff332d RBX: 0000000000000008 RCX: 000000000=
000000c
[  136.830958] RDX: 00000000ffff332d RSI: 000000000000ccd2 RDI: ffff8d8dd=
c8b7e00
[  136.830960] RBP: fffffffffffffff8 R08: ffff8d8ddc8b7e00 R09: 000000000=
000000c
[  136.830961] R10: 0000000000000008 R11: ffff8d8d0ab96e56 R12: ffff8d8dd=
c8b7e00
[  136.830962] R13: ffff8d8d0ab96e56 R14: 0000000000000286 R15: ffff8d8cd=
1a80428
[  136.830966] FS:  0000000000000000(0000) GS:ffff8d9bcc89a000(0000) knlG=
S:0000000000000000
[  136.830968] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  136.830969] CR2: 000000000ccd39b8 CR3: 00000001061fe000 CR4: 000000000=
0350ef0
[  136.830973] Call Trace:
[  136.830975]  <TASK>
[  136.830978]  ? rxe_pool_get_index+0x4b/0x70 [rdma_rxe]
[  136.830986]  rxe_mr_copy_xarray+0xb4/0x170 [rdma_rxe]
[  136.830994]  execute+0x27e/0x320 [rdma_rxe]
[  136.831002]  rxe_receiver+0x4f9/0xce0 [rdma_rxe]
[  136.831009]  ? __pfx_rxe_receiver+0x10/0x10 [rdma_rxe]
[  136.831015]  do_task+0x70/0x220 [rdma_rxe]
[  136.831023]  process_one_work+0x19e/0x370
[  136.831028]  worker_thread+0x1a6/0x310
[  136.831030]  ? __pfx_worker_thread+0x10/0x10
[  136.831032]  kthread+0xe4/0x120
[  136.831035]  ? __pfx_kthread+0x10/0x10
[  136.831038]  ret_from_fork+0x1a1/0x270
[  136.831058]  ? __pfx_kthread+0x10/0x10
[  136.831060]  ret_from_fork_asm+0x1a/0x30
[  136.831066]  </TASK>
[  136.831067] ---[ end trace 0000000000000000 ]---
[  136.831077] rxe0: qp#17 make_send_cqe: non-flush error status =3D 10
[  207.516233] dummy0 speed is unknown, defaulting to 1000

I tried it on a Fedora guest running 7.2.0-rc5: it reliably reproduces th=
e WARNING
at rxe_mr_iova_to_index() (i.e. the responder accepting an out-of-bounds =
index).

I'm still learning the RDMA stack, so my understanding of some of the det=
ails may not
be fully thorough =E2=80=94 apologies if anything above is unclear, and I=
'm happy to correct
or expand on whatever is needed.

Thanks
Gang

>=20
>=20I=E2=80=99d like to use it to reproduce the problem and confirm that =
this commit fixes the reported issue.
>=20
>=20Thanks a lot.
>=20
>=20Zhu Yanjun
>=20
>=20>=20
>=20> Thanks
> >  Gang
> >=20
>=20>  Gang Yan (2):
> >  RDMA/rxe: Fix integer overflow in mr_check_range() leading to OOB
> >  access
> >  DO-NOT-MERGE: selftest: add rxe mr_check_range() overflow reproducer
> >=20
>=20>  drivers/infiniband/sw/rxe/rxe_mr.c | 3 +-
> >  tools/testing/selftests/rdma/Makefile | 8 +-
> >  tools/testing/selftests/rdma/config | 2 +
> >  .../testing/selftests/rdma/rxe_mr_overflow.c | 187 +++++++++++++++++=
+
> >  .../testing/selftests/rdma/rxe_mr_overflow.sh | 132 +++++++++++++
> >  5 files changed, 330 insertions(+), 2 deletions(-)
> >  create mode 100644 tools/testing/selftests/rdma/rxe_mr_overflow.c
> >  create mode 100644 tools/testing/selftests/rdma/rxe_mr_overflow.sh
> >=20
>=20-- Best Regards,
> Yanjun.Zhu
>
--892d20c4-f315-4a33-b425-f22d7dab38b0-1
Content-Type: text/x-c; name="rxe_overflow_repro.c"
Content-Disposition: attachment; filename="rxe_overflow_repro.c"
Content-Transfer-Encoding: base64

Ly8gU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IEdQTC0yLjAKLyoKICogTWluaW1hbCByZXBy
b2R1Y2VyIGZvciB0aGUgcnhlIG1yX2NoZWNrX3JhbmdlKCkgaW92YSBvdmVyZmxvdyAoT09C
KS4KICoKICogT25lIGJpbmFyeTogZm9yaygpIGludG8gYSBzZXJ2ZXIgKHJlZ2lzdGVycyBh
IFVTRVIgTVIpIGFuZCBhIGNsaWVudCB0aGF0CiAqIHBvc3RzIG9uZSBSRE1BLVdyaXRlIHdo
b3NlIHJlbW90ZV9hZGRyIG1ha2VzIGlvdmEgKyBsZW5ndGggd3JhcCB0byAwLAogKiBieXBh
c3NpbmcgdGhlIG9sZCBtcl9jaGVja19yYW5nZSgpIGNoZWNrIGFuZCBPT0ItaW5nIGluIHJ4
ZV9tcl9jb3B5KCkuCiAqCiAqIFByZXJlcXMgKFVidW50dS9EZWJpYW47IGFuYWxvZ291cyBv
biBGZWRvcmEpOgogKiAgIHN1ZG8gYXB0IGluc3RhbGwgLXkgbGliaWJ2ZXJicy1kZXYgbGli
cmRtYWNtLWRldiBnY2MKICogICAjIGtlcm5lbCBuZWVkcyBDT05GSUdfUkRNQV9SWEUsIENP
TkZJR19JTkZJTklCQU5ELAogKiAgICMgQ09ORklHX0lORklOSUJBTkRfVVNFUl9BQ0NFU1Mg
KD1tIG9uIGRpc3RybyBnZW5lcmljIGtlcm5lbHMpCiAqCiAqIEJ1aWxkOgogKiAgIGdjYyAt
TzIgLW8gcmVwcm8gcnhlX292ZXJmbG93X3JlcHJvLmMgLWxpYnZlcmJzIC1scmRtYWNtCiAq
IFJ1biAoYXMgcm9vdCk6CiAqICAgbW9kcHJvYmUgcmRtYV9yeGUKICogICBpcCBsaW5rIGFk
ZCBkdW1teTAgdHlwZSBkdW1teQogKiAgIGlwIGFkZHIgYWRkIDE5Mi4xNjguMTcyLjEvMjQg
ZGV2IGR1bW15MCAmJiBpcCBsaW5rIHNldCBkdW1teTAgdXAKICogICByZG1hIGxpbmsgYWRk
IHJ4ZTAgdHlwZSByeGUgbmV0ZGV2IGR1bW15MAogKiAgIC4vcmVwcm8gMTkyLjE2OC4xNzIu
MQogKgogKiBWZXJkaWN0OiB0aGUgY2xpZW50IG9ubHkgdHJpZ2dlcnMgdGhlIGJ1ZzsgcmVh
ZCB0aGUga2VybmVsIGxvZzoKICogICBncmVwIHJ4ZV9tcl9pb3ZhX3RvX2luZGV4IC9kZXYv
a21zZyAgICAgIyBwcmVzZW50ID0+IHZ1bG5lcmFibGUKICogVW5wYXRjaGVkIGtlcm5lbCBz
aG93czoKICogICBXQVJOSU5HOiAuLi4gYXQgcnhlX21yX2lvdmFfdG9faW5kZXgrLi4uIFty
ZG1hX3J4ZV0KICogICBPb3BzOiAuLi4gcnhlX21yX2NvcHkrLi4uIFtyZG1hX3J4ZV0KICog
UGF0Y2hlZCBrZXJuZWw6IG1yX2NoZWNrX3JhbmdlKCkgcmVqZWN0cyB0aGUgaW92YSwgbG9n
IHN0YXlzIGNsZWFuLgogKi8KI2luY2x1ZGUgPHN0ZGlvLmg+CiNpbmNsdWRlIDxzdGRsaWIu
aD4KI2luY2x1ZGUgPHN0cmluZy5oPgojaW5jbHVkZSA8dW5pc3RkLmg+CiNpbmNsdWRlIDxz
dGRpbnQuaD4KI2luY2x1ZGUgPHN5cy93YWl0Lmg+CiNpbmNsdWRlIDxhcnBhL2luZXQuaD4K
I2luY2x1ZGUgPGluZmluaWJhbmQvdmVyYnMuaD4KI2luY2x1ZGUgPHJkbWEvcmRtYV9jbWEu
aD4KCiNkZWZpbmUgUE9SVCAgICAgNzc5OQojZGVmaW5lIEJBRF9BRERSIDB4ZmZmZmZmZmZm
ZmZmZmZmOFVMTAkvKiBpb3ZhICsgOCB3cmFwcyB0byAwICovCiNkZWZpbmUgV1JfTEVOICAg
OAojZGVmaW5lIE1SX0xFTiAgIDQwOTYKCnN0cnVjdCBtcl9pbmZvIHsgdWludDMyX3Qgcmtl
eTsgdWludDMyX3QgcGFkOyB1aW50NjRfdCBpb3ZhOyB9IF9fYXR0cmlidXRlX18oKHBhY2tl
ZCkpOwoKc3RhdGljIGludCB3YWl0X2V2ZW50KHN0cnVjdCByZG1hX2V2ZW50X2NoYW5uZWwg
KmVjLCBzdHJ1Y3QgcmRtYV9jbV9ldmVudCAqKmV2LAoJCSAgICAgIGVudW0gcmRtYV9jbV9l
dmVudF90eXBlIHdhbnQpCnsKCXdoaWxlIChyZG1hX2dldF9jbV9ldmVudChlYywgZXYpID09
IDApIHsKCQlpZiAoKCpldiktPmV2ZW50ICE9IHdhbnQpIHsKCQkJZnByaW50ZihzdGRlcnIs
ICJjbTogZ290ICVzLCB3YW50ICVzXG4iLAoJCQkJcmRtYV9ldmVudF9zdHIoKCpldiktPmV2
ZW50KSwgcmRtYV9ldmVudF9zdHIod2FudCkpOwoJCQlyZG1hX2Fja19jbV9ldmVudCgqZXYp
OwoJCQlyZXR1cm4gLTE7CgkJfQoJCXJldHVybiAwOwoJfQoJcGVycm9yKCJyZG1hX2dldF9j
bV9ldmVudCIpOwoJcmV0dXJuIC0xOwp9CgovKiBTZXJ2ZXI6IHJlZ2lzdGVyIGEgVVNFUiBN
UiwgYWNjZXB0IG9uZSBjb25uZWN0aW9uLCBoYW5kIG92ZXIgcmtleS9pb3ZhLiAqLwpzdGF0
aWMgaW50IHJ1bl9zZXJ2ZXIoY29uc3QgY2hhciAqYWRkciwgaW50IHJlYWR5X2ZkKQp7Cglz
dHJ1Y3QgcmRtYV9ldmVudF9jaGFubmVsICplYyA9IHJkbWFfY3JlYXRlX2V2ZW50X2NoYW5u
ZWwoKTsKCXN0cnVjdCByZG1hX2NtX2lkICpsaWQgPSBOVUxMLCAqaWQgPSBOVUxMOwoJc3Ry
dWN0IHJkbWFfY21fZXZlbnQgKmV2OwoJc3RydWN0IGlidl9wZCAqcGQ7IHN0cnVjdCBpYnZf
Y3EgKmNxOyBzdHJ1Y3QgaWJ2X21yICptcjsgdm9pZCAqYnVmOwoJc3RydWN0IHNvY2thZGRy
X2luIHNpbiA9IHsgLnNpbl9mYW1pbHkgPSBBRl9JTkVULCAuc2luX3BvcnQgPSBodG9ucyhQ
T1JUKSB9OwoJaW50IHJjID0gMDsKCglpZiAoIWVjIHx8IHJkbWFfY3JlYXRlX2lkKGVjLCAm
bGlkLCBOVUxMLCBSRE1BX1BTX1RDUCkpIHsgcGVycm9yKCJjbSIpOyBjbG9zZShyZWFkeV9m
ZCk7IHJldHVybiAxOyB9CglpZiAoIWluZXRfcHRvbihBRl9JTkVULCBhZGRyLCAmc2luLnNp
bl9hZGRyKSkgeyBmcHJpbnRmKHN0ZGVyciwgImJhZCBhZGRyXG4iKTsgY2xvc2UocmVhZHlf
ZmQpOyByZXR1cm4gMTsgfQoJaWYgKHJkbWFfYmluZF9hZGRyKGxpZCwgKHN0cnVjdCBzb2Nr
YWRkciAqKSZzaW4pIHx8IHJkbWFfbGlzdGVuKGxpZCwgMSkpIHsKCQlwZXJyb3IoImJpbmQv
bGlzdGVuIik7CQkvKiBsZXQgdGhlIGNsaWVudCBzdG9wIHdhaXRpbmcgKi8KCQljbG9zZShy
ZWFkeV9mZCk7CgkJcmV0dXJuIDE7Cgl9CglpZiAod3JpdGUocmVhZHlfZmQsICJ4IiwgMSkg
PCAwKQoJCXBlcnJvcigibm90aWZ5IGNsaWVudCIpOwoJY2xvc2UocmVhZHlfZmQpOwoKCWlm
ICh3YWl0X2V2ZW50KGVjLCAmZXYsIFJETUFfQ01fRVZFTlRfQ09OTkVDVF9SRVFVRVNUKSkg
cmV0dXJuIDE7CglpZCA9IGV2LT5pZDsKCglwZCAgPSBpYnZfYWxsb2NfcGQoaWQtPnZlcmJz
KTsKCWNxICA9IGlidl9jcmVhdGVfY3EoaWQtPnZlcmJzLCA0LCBOVUxMLCBOVUxMLCAwKTsK
CWJ1ZiA9IGNhbGxvYygxLCBNUl9MRU4pOwoJbXIgID0gaWJ2X3JlZ19tcihwZCwgYnVmLCBN
Ul9MRU4sCgkJCSBJQlZfQUNDRVNTX0xPQ0FMX1dSSVRFIHwgSUJWX0FDQ0VTU19SRU1PVEVf
V1JJVEUpOwoJaWYgKCFwZCB8fCAhY3EgfHwgIW1yKSB7IHBlcnJvcigicGQvY3EvbXIiKTsg
cmMgPSAxOyBnb3RvIGFjazsgfQoKCXN0cnVjdCBpYnZfcXBfaW5pdF9hdHRyIHFhID0gewoJ
CS5zZW5kX2NxID0gY3EsIC5yZWN2X2NxID0gY3EsIC5xcF90eXBlID0gSUJWX1FQVF9SQywK
CQkuY2FwID0geyAubWF4X3NlbmRfd3IgPSA0LCAubWF4X3JlY3Zfd3IgPSA0LCAubWF4X3Nl
bmRfc2dlID0gMiwgLm1heF9yZWN2X3NnZSA9IDIgfSwKCX07CglpZiAocmRtYV9jcmVhdGVf
cXAoaWQsIHBkLCAmcWEpKSB7IHBlcnJvcigiY3JlYXRlX3FwIik7IHJjID0gMTsgZ290byBh
Y2s7IH0KCglzdHJ1Y3QgbXJfaW5mbyBpbmZvID0geyAucmtleSA9IG1yLT5ya2V5LCAuaW92
YSA9ICh1aW50NjRfdCkodWludHB0cl90KWJ1ZiB9OwoJc3RydWN0IHJkbWFfY29ubl9wYXJh
bSBwID0gewoJCS5wcml2YXRlX2RhdGEgPSAmaW5mbywgLnByaXZhdGVfZGF0YV9sZW4gPSBz
aXplb2YoaW5mbyksCgkJLmluaXRpYXRvcl9kZXB0aCA9IDEsIC5yZXNwb25kZXJfcmVzb3Vy
Y2VzID0gMSwKCX07CglpZiAocmRtYV9hY2NlcHQoaWQsICZwKSkgeyBwZXJyb3IoImFjY2Vw
dCIpOyByYyA9IDE7IH0KYWNrOgoJcmRtYV9hY2tfY21fZXZlbnQoZXYpOwoJc2xlZXAoMyk7
CS8qIGxldCB0aGUgY2xpZW50IGZpbmlzaCBpdHMgKG1hbGljaW91cykgb3BlcmF0aW9uICov
CglyZXR1cm4gcmM7Cn0KCi8qIENsaWVudDogY29ubmVjdCwgZmV0Y2ggcmtleSwgcG9zdCBv
bmUgY3JhZnRlZCBSRE1BLVdyaXRlLiAqLwpzdGF0aWMgaW50IHJ1bl9jbGllbnQoY29uc3Qg
Y2hhciAqYWRkciwgaW50IHJlYWR5X2ZkKQp7CglzdHJ1Y3QgcmRtYV9ldmVudF9jaGFubmVs
ICplYyA9IHJkbWFfY3JlYXRlX2V2ZW50X2NoYW5uZWwoKTsKCXN0cnVjdCByZG1hX2NtX2lk
ICppZCA9IE5VTEw7CglzdHJ1Y3QgcmRtYV9jbV9ldmVudCAqZXY7CglzdHJ1Y3QgaWJ2X3Bk
ICpwZDsgc3RydWN0IGlidl9jcSAqY3E7IHN0cnVjdCBpYnZfbXIgKm1yOyB2b2lkICpidWY7
CglzdHJ1Y3QgaWJ2X3NnZSBzZ2U7IHN0cnVjdCBpYnZfc2VuZF93ciB3ciwgKmJhZDsKCXN0
cnVjdCBzb2NrYWRkcl9pbiBzaW4gPSB7IC5zaW5fZmFtaWx5ID0gQUZfSU5FVCwgLnNpbl9w
b3J0ID0gaHRvbnMoUE9SVCkgfTsKCWNoYXIgdG1wOwoKCWlmICghZWMgfHwgcmRtYV9jcmVh
dGVfaWQoZWMsICZpZCwgTlVMTCwgUkRNQV9QU19UQ1ApKSB7IHBlcnJvcigiY20iKTsgcmV0
dXJuIDE7IH0KCWlmICghaW5ldF9wdG9uKEFGX0lORVQsIGFkZHIsICZzaW4uc2luX2FkZHIp
KSB7IGZwcmludGYoc3RkZXJyLCAiYmFkIGFkZHJcbiIpOyByZXR1cm4gMTsgfQoJaWYgKHJl
YWQocmVhZHlfZmQsICZ0bXAsIDEpIDwgMCkgeyBwZXJyb3IoIndhaXQgc2VydmVyIik7IGNs
b3NlKHJlYWR5X2ZkKTsgcmV0dXJuIDE7IH0KCWNsb3NlKHJlYWR5X2ZkKTsJLyogc2VydmVy
IGlzIGxpc3RlbmluZyAob3IgZ2F2ZSB1cDsgY29ubmVjdCB3aWxsIGZhaWwgdGhlbikgKi8K
CglpZiAocmRtYV9yZXNvbHZlX2FkZHIoaWQsIE5VTEwsIChzdHJ1Y3Qgc29ja2FkZHIgKikm
c2luLCA1MDAwKSkgeyBwZXJyb3IoInJlc29sdmVfYWRkciIpOyByZXR1cm4gMTsgfQoJaWYg
KHdhaXRfZXZlbnQoZWMsICZldiwgUkRNQV9DTV9FVkVOVF9BRERSX1JFU09MVkVEKSkKCQly
ZXR1cm4gMTsKCXJkbWFfYWNrX2NtX2V2ZW50KGV2KTsKCWlmIChyZG1hX3Jlc29sdmVfcm91
dGUoaWQsIDUwMDApKSB7IHBlcnJvcigicmVzb2x2ZV9yb3V0ZSIpOyByZXR1cm4gMTsgfQoJ
aWYgKHdhaXRfZXZlbnQoZWMsICZldiwgUkRNQV9DTV9FVkVOVF9ST1VURV9SRVNPTFZFRCkp
CgkJcmV0dXJuIDE7CglyZG1hX2Fja19jbV9ldmVudChldik7CgoJcGQgID0gaWJ2X2FsbG9j
X3BkKGlkLT52ZXJicyk7CgljcSAgPSBpYnZfY3JlYXRlX2NxKGlkLT52ZXJicywgNCwgTlVM
TCwgTlVMTCwgMCk7CglidWYgPSBjYWxsb2MoMSwgTVJfTEVOKTsKCW1yICA9IGlidl9yZWdf
bXIocGQsIGJ1ZiwgTVJfTEVOLCBJQlZfQUNDRVNTX0xPQ0FMX1dSSVRFKTsKCXN0cnVjdCBp
YnZfcXBfaW5pdF9hdHRyIHFhID0gewoJCS5zZW5kX2NxID0gY3EsIC5yZWN2X2NxID0gY3Es
IC5xcF90eXBlID0gSUJWX1FQVF9SQywKCQkuY2FwID0geyAubWF4X3NlbmRfd3IgPSA0LCAu
bWF4X3JlY3Zfd3IgPSA0LCAubWF4X3NlbmRfc2dlID0gMiwgLm1heF9yZWN2X3NnZSA9IDIg
fSwKCX07CglpZiAoIXBkIHx8ICFjcSB8fCAhbXIgfHwgcmRtYV9jcmVhdGVfcXAoaWQsIHBk
LCAmcWEpKSB7IHBlcnJvcigic2V0dXAiKTsgcmV0dXJuIDE7IH0KCglzdHJ1Y3QgcmRtYV9j
b25uX3BhcmFtIHAgPSB7IC5pbml0aWF0b3JfZGVwdGggPSAxLCAucmVzcG9uZGVyX3Jlc291
cmNlcyA9IDEsIC5yZXRyeV9jb3VudCA9IDMgfTsKCWlmIChyZG1hX2Nvbm5lY3QoaWQsICZw
KSB8fCB3YWl0X2V2ZW50KGVjLCAmZXYsIFJETUFfQ01fRVZFTlRfRVNUQUJMSVNIRUQpKSB7
IHBlcnJvcigiY29ubmVjdCIpOyByZXR1cm4gMTsgfQoJc3RydWN0IG1yX2luZm8gaW5mbyA9
IHswfTsKCWlmIChldi0+cGFyYW0uY29ubi5wcml2YXRlX2RhdGFfbGVuID49IChpbnQpc2l6
ZW9mKGluZm8pKQoJCW1lbWNweSgmaW5mbywgZXYtPnBhcmFtLmNvbm4ucHJpdmF0ZV9kYXRh
LCBzaXplb2YoaW5mbykpOwoJcmRtYV9hY2tfY21fZXZlbnQoZXYpOwoKCXNnZSA9IChzdHJ1
Y3QgaWJ2X3NnZSl7IC5hZGRyID0gKHVpbnRwdHJfdClidWYsIC5sZW5ndGggPSBXUl9MRU4s
IC5sa2V5ID0gbXItPmxrZXkgfTsKCW1lbXNldCgmd3IsIDAsIHNpemVvZih3cikpOwoJd3Iu
d3JfaWQgPSAweGRlYWQ7Cgl3ci5vcGNvZGUgPSBJQlZfV1JfUkRNQV9XUklURTsKCXdyLnNl
bmRfZmxhZ3MgPSBJQlZfU0VORF9TSUdOQUxFRDsKCXdyLnNnX2xpc3QgPSAmc2dlOwoJd3Iu
bnVtX3NnZSA9IDE7Cgl3ci53ci5yZG1hLnJlbW90ZV9hZGRyID0gQkFEX0FERFI7CS8qIGlv
dmEgKyA4IHdyYXBzIHRvIDAgKi8KCXdyLndyLnJkbWEucmtleSA9IGluZm8ucmtleTsKCglp
YnZfcG9zdF9zZW5kKGlkLT5xcCwgJndyLCAmYmFkKTsKCXByaW50ZigiW2NsaWVudF0gcG9z
dGVkIFJETUEtV3JpdGUgd2l0aCB3cmFwcGluZyBpb3ZhOyBub3cgY2hlY2sgZG1lc2c6XG4i
KTsKCXByaW50ZigiICAgIGdyZXAgcnhlX21yX2lvdmFfdG9faW5kZXggL2Rldi9rbXNnICAg
ICMgcHJlc2VudCA9PiB2dWxuZXJhYmxlXG4iKTsKCXNsZWVwKDIpOwkvKiBsZXQgdGhlIHJl
c3BvbmRlciBwcm9jZXNzIHRoZSBXUklURSBhbmQgaGl0IHRoZSBPT0IgKi8KCXJldHVybiAw
Owp9CgppbnQgbWFpbihpbnQgYXJnYywgY2hhciAqKmFyZ3YpCnsKCWNvbnN0IGNoYXIgKmFk
ZHIgPSBhcmdjID4gMSA/IGFyZ3ZbMV0gOiAiMTkyLjE2OC4xNzIuMSI7CglpbnQgc3luY2Zk
WzJdLCByYyA9IDE7CgoJaWYgKHBpcGUoc3luY2ZkKSkgeyBwZXJyb3IoInBpcGUiKTsgcmV0
dXJuIDE7IH0KCXBpZF90IHBpZCA9IGZvcmsoKTsKCWlmIChwaWQgPCAwKSB7IHBlcnJvcigi
Zm9yayIpOyByZXR1cm4gMTsgfQoJaWYgKHBpZCA9PSAwKSB7CQkJLyogY2hpbGQgPSBjbGll
bnQgKi8KCQljbG9zZShzeW5jZmRbMV0pOwoJCV9leGl0KHJ1bl9jbGllbnQoYWRkciwgc3lu
Y2ZkWzBdKSk7Cgl9CgljbG9zZShzeW5jZmRbMF0pOwkJLyogcGFyZW50ID0gc2VydmVyICov
CglyYyA9IHJ1bl9zZXJ2ZXIoYWRkciwgc3luY2ZkWzFdKTsKCglpbnQgc3Q7IHdhaXQoJnN0
KTsKCWlmIChXSUZFWElURUQoc3QpKSByYyA9IFdFWElUU1RBVFVTKHN0KTsKCXJldHVybiBy
YzsKfQo=
--892d20c4-f315-4a33-b425-f22d7dab38b0-1--
