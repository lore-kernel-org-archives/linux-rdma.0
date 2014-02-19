From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH v2 00/12] T10-DIF Initial support for iSER target
Date: Wed, 19 Feb 2014 15:14:50 -0800
Message-ID: <1392851690.22195.7.camel@haakon3.risingtidesystems.com>
References: <1392825025-29943-1-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1392825025-29943-1-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>
Cc: target-devel@vger.kernel.org, roland@kernel.org, linux-rdma@vger.kernel.org, oren@mellanox.com, martin.petersen@oracle.com
List-Id: linux-rdma@vger.kernel.org

On Wed, 2014-02-19 at 17:50 +0200, Sagi Grimberg wrote:
> Hey Nic,
>=20
> I addressed your comments in the this set. I'll try to send the
> initiator code for review in the next couple of days.
>=20
> This patchset introduces target side T10-PI offload support over
> RDMA. Currently the implementation is for iSER transport but can
> be easily extended to SRP (or FCoE in the future).
>=20
> Should mention that this patchset depends on RDMA signature
> verbs making it for inclusion which will hopefully happen in
> near future.
>=20
> This code was tested against iSER legacy initiator, and also
> initiator that uses T10-PI offload as well. I'll clean up the
> initiator code in the following days and submit that as well.
>=20
> This code works under medium loads using backstores:
> - FileIO with DIF emulation.
> - RD with DIF emulation.
> - iBLOCK (scsi_debug with DIF support).
>=20
> Chnages from v1:
> - Rebased rdma_dif (3.14-rc2)
> - Target core:
>   - Pass zero_flag=3Dtrue to alloc_sgl for protection buffers
>   - Removed Unneeded inline function rwprotect
>   - Pass is_write bool to sbc_set_prot_op_checks
>   - Send failure response for absence of protection buffers
>     when needed.
> - iSER:
>   - Removed unneeded assignments in isert_set_sig_attrs
>=20
> Chnages from v0:
> - Rebased from for-next
> - Target core:
>   - Don't minor fixes for check_prot - to support transports
>     that doesn't use submit_map_sgls.
>   - file  format - use escape values.
>   - Removed redundant prot_handover.
>   - Added protection checks and operation set.
> - iSER:
>   - Added preperation routines for mapping/unmapping buffers
>     to ease the amount of code in isert_reg_rdma.
>   - Fixed print of DIF error (sector instead of offset).
>   - Fix RDMA length for protection on wire domain.
>   - Refactored reg_sig_mr to use helper routines.
>=20

Hey Sagi,

=46YI, this series did not compile:

drivers/infiniband/ulp/isert/ib_isert.c: In function =E2=80=98isert_reg=
_sig_mr=E2=80=99:
drivers/infiniband/ulp/isert/ib_isert.c:2531:2: error: expected =E2=80=98=
;=E2=80=99 before =E2=80=98ret=E2=80=99
drivers/infiniband/ulp/isert/ib_isert.c: In function =E2=80=98isert_reg=
_rdma=E2=80=99:
drivers/infiniband/ulp/isert/ib_isert.c:2611:24: warning: comparison be=
tween =E2=80=98enum target_prot_type=E2=80=99 and =E2=80=98enum target_=
prot_op=E2=80=99 [-Wenum-compare]
drivers/infiniband/ulp/isert/ib_isert.c:2625:24: warning: comparison be=
tween =E2=80=98enum target_prot_type=E2=80=99 and =E2=80=98enum target_=
prot_op=E2=80=99 [-Wenum-compare]
drivers/infiniband/ulp/isert/ib_isert.c:2667:43: warning: comparison be=
tween =E2=80=98enum target_prot_type=E2=80=99 and =E2=80=98enum target_=
prot_op=E2=80=99 [-Wenum-compare]
drivers/infiniband/ulp/isert/ib_isert.c: In function =E2=80=98isert_put=
_datain=E2=80=99:
drivers/infiniband/ulp/isert/ib_isert.c:2711:24: warning: comparison be=
tween =E2=80=98enum target_prot_type=E2=80=99 and =E2=80=98enum target_=
prot_op=E2=80=99 [-Wenum-compare]
drivers/infiniband/ulp/isert/ib_isert.c:2732:24: warning: comparison be=
tween =E2=80=98enum target_prot_type=E2=80=99 and =E2=80=98enum target_=
prot_op=E2=80=99 [-Wenum-compare]
drivers/infiniband/ulp/isert/ib_isert.c: At top level:
drivers/infiniband/ulp/isert/ib_isert.c:2468:1: warning: =E2=80=98isert=
_set_sig_attrs=E2=80=99 defined but not used [-Wunused-function]
drivers/target/target_core_transport.c: In function =E2=80=98transport_=
generic_new_cmd=E2=80=99:
drivers/target/target_core_transport.c:2221:22: warning: comparison bet=
ween =E2=80=98enum target_prot_type=E2=80=99 and =E2=80=98enum target_p=
rot_op=E2=80=99 [-Wenum-compare]

Squashing the following patch(es) into your original series, and applie=
d
to target-pending/rdma-dif.

Thank you,

--nab

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniba=
nd/ulp/isert/ib_isert.
index 04bdd79..b7c8cd7 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -2527,7 +2527,7 @@ isert_reg_sig_mr(struct isert_conn *isert_conn, s=
truct se_cmd *se_cmd,
        int ret;
        u32 key;
=20
-       memset(&sig_attrs, 0, sizeof(sig_attrs))
+       memset(&sig_attrs, 0, sizeof(sig_attrs));
        ret =3D isert_set_sig_attrs(se_cmd, &sig_attrs);
        if (ret)
                goto err;
@@ -2608,7 +2608,7 @@ isert_reg_rdma(struct iscsi_conn *conn, struct is=
csi_cmd *cmd,
                return ret;
=20
        if (wr->data.dma_nents !=3D 1 ||
-           se_cmd->prot_type !=3D TARGET_PROT_NORMAL) {
+           se_cmd->prot_op !=3D TARGET_PROT_NORMAL) {
                spin_lock_irqsave(&isert_conn->conn_lock, flags);
                fr_desc =3D list_first_entry(&isert_conn->conn_fr_pool,
                                           struct fast_reg_descriptor, =
list);
@@ -2622,7 +2622,7 @@ isert_reg_rdma(struct iscsi_conn *conn, struct is=
csi_cmd *cmd,
        if (ret)
                goto unmap_cmd;
=20
-       if (se_cmd->prot_type !=3D TARGET_PROT_NORMAL) {
+       if (se_cmd->prot_op !=3D TARGET_PROT_NORMAL) {
                struct ib_sge prot_sge, sig_sge;
=20
                if (se_cmd->t_prot_sg) {
@@ -2664,7 +2664,7 @@ isert_reg_rdma(struct iscsi_conn *conn, struct is=
csi_cmd *cmd,
                send_wr->opcode =3D IB_WR_RDMA_WRITE;
                send_wr->wr.rdma.remote_addr =3D isert_cmd->read_va;
                send_wr->wr.rdma.rkey =3D isert_cmd->read_stag;
-               send_wr->send_flags =3D se_cmd->prot_type =3D=3D TARGET=
_PROT_NORMAL ?
+               send_wr->send_flags =3D se_cmd->prot_op =3D=3D TARGET_P=
ROT_NORMAL ?
                                      0 : IB_SEND_SIGNALED;
        } else {
                send_wr->opcode =3D IB_WR_RDMA_READ;
@@ -2708,7 +2708,7 @@ isert_put_datain(struct iscsi_conn *conn, struct =
iscsi_cmd *cmd)
                return rc;
        }
=20
-       if (se_cmd->prot_type =3D=3D TARGET_PROT_NORMAL) {
+       if (se_cmd->prot_op =3D=3D TARGET_PROT_NORMAL) {
                /*
                 * Build isert_conn->tx_desc for iSCSI response PDU and=
 attach
                 */
@@ -2729,7 +2729,7 @@ isert_put_datain(struct iscsi_conn *conn, struct =
iscsi_cmd *cmd)
                atomic_dec(&isert_conn->post_send_buf_count);
        }
=20
-       if (se_cmd->prot_type =3D=3D TARGET_PROT_NORMAL)
+       if (se_cmd->prot_op =3D=3D TARGET_PROT_NORMAL)
                pr_debug("Cmd: %p posted RDMA_WRITE + Response for iSER=
 Data "
                         "READ\n", isert_cmd);
        else
diff --git a/drivers/target/target_core_transport.c b/drivers/target/ta=
rget_core_transport.c
index a45d628..954e7ed 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2218,7 +2218,7 @@ transport_generic_new_cmd(struct se_cmd *cmd)
                                return TCM_LOGICAL_UNIT_COMMUNICATION_F=
AILURE;
                }
=20
-               if (cmd->prot_type !=3D TARGET_PROT_NORMAL) {
+               if (cmd->prot_op !=3D TARGET_PROT_NORMAL) {
                        ret =3D target_alloc_sgl(&cmd->t_prot_sg,
                                               &cmd->t_prot_nents,
                                               cmd->prot_length, true);
