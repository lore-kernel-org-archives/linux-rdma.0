From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v2 03/12] IB/ocrdma: Improve size determinations in ten
 functions
Date: Sun, 23 Apr 2017 10:33:11 +0300
Message-ID: <20170423073311.GA14088@mtr-leonro.local>
References: <fc421509-4069-da8a-b308-60b49ea91ada@users.sourceforge.net>
 <1492720999.3041.18.camel@redhat.com>
 <86425035-7da8-d2b1-8544-d4f7540d50c6@users.sourceforge.net>
 <755f6c2c-03a2-7248-a5e3-9190d119cdaf@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="jn/MQTzma+jNUHFC"
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <755f6c2c-03a2-7248-a5e3-9190d119cdaf@users.sourceforge.net>
Sender: kernel-janitors-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: SF Markus Elfring <elfring@users.sourceforge.net>, Devesh Sharma <devesh.sharma@avagotech.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Sean Hefty <sean.hefty@intel.com>, Selvin Xavier <selvin.xavier@avagotech.com>, Yuval Shaia <yuval.shaia@oracle.com>, linux-rdma@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--jn/MQTzma+jNUHFC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Apr 22, 2017 at 04:36:19PM +0200, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Sat, 22 Apr 2017 13:26:49 +0200
>
> Replace the specification of data types by pointer dereferences
> as the parameter for the operator "sizeof" to make the corresponding size
> determinations a bit safer according to the Linux coding style convention.
>
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>
> v2:
> Changes were rebased on source files from Linux next-20170421.
> These were recombined as requested by Doug Ledford.

Hi Doug,

I recommend you to be extra cautious with this blind automatic
conversions. It requires inspection that every size before and after
match each other.

I already asked it and would be like to repeat it. Please DON'T take any
patches from Markus, which are related to mlx4/mlx5/rxe without our explicit
review of them.

Thanks

>
>  drivers/infiniband/hw/ocrdma/ocrdma_hw.c    | 28 ++++++++++++----------------
>  drivers/infiniband/hw/ocrdma/ocrdma_main.c  |  2 +-
>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |  4 ++--
>  3 files changed, 15 insertions(+), 19 deletions(-)
>
> diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
> index d5a3127b6df8..7e58a74102f6 100644
> --- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
> +++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
> @@ -352,7 +352,7 @@ static void *ocrdma_init_emb_mqe(u8 opcode, u32 cmd_len)
>  {
>  	struct ocrdma_mqe *mqe;
>
> -	mqe = kzalloc(sizeof(struct ocrdma_mqe), GFP_KERNEL);
> +	mqe = kzalloc(sizeof(*mqe), GFP_KERNEL);
>  	if (!mqe)
>  		return NULL;
>  	mqe->hdr.spcl_sge_cnt_emb |=
> @@ -890,7 +890,7 @@ static int ocrdma_mq_cq_handler(struct ocrdma_dev *dev, u16 cq_id)
>  			ocrdma_process_acqe(dev, cqe);
>  		else if (cqe->valid_ae_cmpl_cons & OCRDMA_MCQE_CMPL_MASK)
>  			ocrdma_process_mcqe(dev, cqe);
> -		memset(cqe, 0, sizeof(struct ocrdma_mcqe));
> +		memset(cqe, 0, sizeof(*cqe));
>  		ocrdma_mcq_inc_tail(dev);
>  	}
>  	ocrdma_ring_cq_db(dev, dev->mq.cq.id, true, false, cqe_popped);
> @@ -1302,7 +1302,7 @@ int ocrdma_mbx_rdma_stats(struct ocrdma_dev *dev, bool reset)
>  	mqe->u.nonemb_req.sge[0].len = dev->stats_mem.size;
>
>  	/* Cache the old stats */
> -	memcpy(old_stats, req, sizeof(struct ocrdma_rdma_stats_resp));
> +	memcpy(old_stats, req, sizeof(*old_stats));
>  	memset(req, 0, dev->stats_mem.size);
>
>  	ocrdma_init_mch((struct ocrdma_mbx_hdr *)req,
> @@ -1315,7 +1315,7 @@ int ocrdma_mbx_rdma_stats(struct ocrdma_dev *dev, bool reset)
>  	status = ocrdma_nonemb_mbx_cmd(dev, mqe, dev->stats_mem.va);
>  	if (status)
>  		/* Copy from cache, if mbox fails */
> -		memcpy(req, old_stats, sizeof(struct ocrdma_rdma_stats_resp));
> +		memcpy(req, old_stats, sizeof(*old_stats));
>  	else
>  		ocrdma_le32_to_cpu(req, dev->stats_mem.size);
>
> @@ -1331,7 +1331,7 @@ static int ocrdma_mbx_get_ctrl_attribs(struct ocrdma_dev *dev)
>  	struct ocrdma_get_ctrl_attribs_rsp *ctrl_attr_rsp;
>  	struct mgmt_hba_attribs *hba_attribs;
>
> -	mqe = kzalloc(sizeof(struct ocrdma_mqe), GFP_KERNEL);
> +	mqe = kzalloc(sizeof(*mqe), GFP_KERNEL);
>  	if (!mqe)
>  		return status;
>
> @@ -1595,8 +1595,7 @@ void ocrdma_alloc_pd_pool(struct ocrdma_dev *dev)
>  {
>  	int status;
>
> -	dev->pd_mgr = kzalloc(sizeof(struct ocrdma_pd_resource_mgr),
> -			      GFP_KERNEL);
> +	dev->pd_mgr = kzalloc(sizeof(*dev->pd_mgr), GFP_KERNEL);
>  	if (!dev->pd_mgr)
>  		return;
>
> @@ -2487,7 +2486,7 @@ int ocrdma_mbx_query_qp(struct ocrdma_dev *dev, struct ocrdma_qp *qp,
>  	if (status)
>  		goto mbx_err;
>  	rsp = (struct ocrdma_query_qp_rsp *)cmd;
> -	memcpy(param, &rsp->params, sizeof(struct ocrdma_qp_params));
> +	memcpy(param, &rsp->params, sizeof(*param));
>  mbx_err:
>  	kfree(cmd);
>  	return status;
> @@ -2901,9 +2900,8 @@ static int ocrdma_mbx_get_dcbx_config(struct ocrdma_dev *dev, u32 ptype,
>  	struct pci_dev *pdev = dev->nic_info.pdev;
>  	struct ocrdma_mqe_sge *mqe_sge = cmd.u.nonemb_req.sge;
>
> -	memset(&cmd, 0, sizeof(struct ocrdma_mqe));
> -	cmd.hdr.pyld_len = max_t (u32, sizeof(struct ocrdma_get_dcbx_cfg_rsp),
> -					sizeof(struct ocrdma_get_dcbx_cfg_req));
> +	memset(&cmd, 0, sizeof(cmd));
> +	cmd.hdr.pyld_len = max_t(u32, sizeof(*rsp), sizeof(*req));
>  	req = dma_alloc_coherent(&pdev->dev, cmd.hdr.pyld_len, &pa, GFP_KERNEL);
>  	if (!req) {
>  		status = -ENOMEM;
> @@ -2915,8 +2913,7 @@ static int ocrdma_mbx_get_dcbx_config(struct ocrdma_dev *dev, u32 ptype,
>  	mqe_sge->pa_lo = (u32) (pa & 0xFFFFFFFFUL);
>  	mqe_sge->pa_hi = (u32) upper_32_bits(pa);
>  	mqe_sge->len = cmd.hdr.pyld_len;
> -
> -	memset(req, 0, sizeof(struct ocrdma_get_dcbx_cfg_req));
> +	memset(req, 0, sizeof(*req));
>  	ocrdma_init_mch(&req->hdr, OCRDMA_CMD_GET_DCBX_CONFIG,
>  			OCRDMA_SUBSYS_DCBX, cmd.hdr.pyld_len);
>  	req->param_type = ptype;
> @@ -2926,9 +2923,8 @@ static int ocrdma_mbx_get_dcbx_config(struct ocrdma_dev *dev, u32 ptype,
>  		goto mbx_err;
>
>  	rsp = (struct ocrdma_get_dcbx_cfg_rsp *)req;
> -	ocrdma_le32_to_cpu(rsp, sizeof(struct ocrdma_get_dcbx_cfg_rsp));
> -	memcpy(dcbxcfg, &rsp->cfg, sizeof(struct ocrdma_dcbx_cfg));
> -
> +	ocrdma_le32_to_cpu(rsp, sizeof(*rsp));
> +	memcpy(dcbxcfg, &rsp->cfg, sizeof(*dcbxcfg));
>  mbx_err:
>  	dma_free_coherent(&pdev->dev, cmd.hdr.pyld_len, req, pa);
>  mem_err:
> diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
> index 91705b10f269..e2aa67d6cbb8 100644
> --- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
> +++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
> @@ -303,7 +303,7 @@ static struct ocrdma_dev *ocrdma_add(struct be_dev_info *dev_info)
>  	u8 lstate = 0;
>  	struct ocrdma_dev *dev;
>
> -	dev = (struct ocrdma_dev *)ib_alloc_device(sizeof(struct ocrdma_dev));
> +	dev = (struct ocrdma_dev *)ib_alloc_device(sizeof(*dev));
>  	if (!dev) {
>  		pr_err("Unable to allocate ib device\n");
>  		return NULL;
> diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> index 146601c97158..f12d1d458f28 100644
> --- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> +++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> @@ -1914,7 +1914,7 @@ struct ib_srq *ocrdma_create_srq(struct ib_pd *ibpd,
>  		if (srq->idx_bit_fields == NULL)
>  			goto arm_err;
>  		memset(srq->idx_bit_fields, 0xff,
> -		       srq->bit_fields_len * sizeof(u32));
> +		       srq->bit_fields_len * sizeof(*srq->idx_bit_fields));
>  	}
>
>  	if (init_attr->attr.srq_limit) {
> @@ -3029,7 +3029,7 @@ struct ib_mr *ocrdma_alloc_mr(struct ib_pd *ibpd,
>  	if (!mr)
>  		return ERR_PTR(-ENOMEM);
>
> -	mr->pages = kcalloc(max_num_sg, sizeof(u64), GFP_KERNEL);
> +	mr->pages = kcalloc(max_num_sg, sizeof(*mr->pages), GFP_KERNEL);
>  	if (!mr->pages) {
>  		status = -ENOMEM;
>  		goto pl_err;
> --
> 2.12.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--jn/MQTzma+jNUHFC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlj8WLcACgkQ5GN7iDZy
WKco9xAA0E3aRhJ7WUXWsG/ycWqhhEuYaRyb1L17JSAzZ8cXKuj3C3anXGS//L5v
owqrld4oo96bvYUrMwQ+a2d2cEDR8stcJpEl8UWROky0MIK6O21V8/YLmPQbfY7b
gg33JN1WWRwTA0FGP419YlzPhNyRmx8aN4O4Tvp/NNMMizTTuSwcub7c6Iz1kGjD
LhguXoeZVlnvrSoG5MPVnH184zdZR1rETgehBnzm48OFAJ/HA5OFwfelL4iQj8jF
ZDZdqt/i9mV9C85SyrpVjpw0ow5LuRmZOTgvxbc0xUt4FSabf1b+keTaSIphVQdy
TiH9UalkTwhI/Ac/noOE0LSJYCgpvPGNE4S1unNvjyMnrRN7e7REt8A+CXrxKkEc
sgtOiEBHa/fHApEsj+tpLy5GphZH9/xzW2LP1mtQDqPVSDninGOlerzSayVPM8ZA
hKZRVDd48+RtLvASI+cMbMrLMHFtd4Hty3lhiVU75zmgUI3K9f7PkfS+azueI+kP
EwKKfFGCBXGa7xpwpz/87EY3i2eO2/vMWUWxlVHFwjtib1xQ8OC48eTGzIkm+qtf
1rPN9q9V+NGIRQBY4zbSpJjAGp77XO6ih3e4e+nebZ2oghE+izGcZrHWJBrbZnha
Z9ZbLqkfI3sc0zAyx2pdD8w8zzRVcKD3KMIKQZbygHaTI145ZXA=
=kNIh
-----END PGP SIGNATURE-----

--jn/MQTzma+jNUHFC--
