From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH for-next 13/20] IB/hns: Add check for some NULL pointer
 scenes
Date: Tue, 13 Sep 2016 09:59:37 +0300
Message-ID: <20160913065937.GS8812@leon.nu>
References: <1473417051-99560-1-git-send-email-salil.mehta@huawei.com>
 <1473417051-99560-14-git-send-email-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="jesV4P1FjH8FXPjZ"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1473417051-99560-14-git-send-email-salil.mehta@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Salil Mehta <salil.mehta@huawei.com>
Cc: dledford@redhat.com, xavier.huwei@huawei.com, oulijun@huawei.com, yisen.zhuang@huawei.com, xuwei5@hisilicon.com, mehta.salil.lnk@gmail.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, linuxarm@huawei.com, "Dongdong Huang(Donald)" <hdd.huang@huawei.com>
List-Id: linux-rdma@vger.kernel.org


--jesV4P1FjH8FXPjZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 09, 2016 at 06:30:44PM +0800, Salil Mehta wrote:
> From: Lijun Ou <oulijun@huawei.com>
>
> Some pointers have not be checked when they are null,
> so we add check for them.
>
> Signed-off-by: Lijun Ou <oulijun@huawei.com>
> Signed-off-by: Dongdong Huang(Donald) <hdd.huang@huawei.com>
> Reviewed-by:  Wei Hu (Xavier) <xavier.huwei@huawei.com>
> Signed-off-by: Salil Mehta <salil.mehta@huawei.com>

I may admit that I didn't check your code to read the implementations of
get_send_wqe() and hns_roce_v1_poll_one(), but based on my assumption
that the code is similar to mlx4.

These failures can't occur.

Can you throw a light on how did you find them and check it?

> ---
>  drivers/infiniband/hw/hns/hns_roce_hw_v1.c |   11 +++++++++++
>  1 file changed, 11 insertions(+)
>
> diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
> index f0d6315..e3e154c 100644
> --- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
> +++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
> @@ -92,6 +92,12 @@ int hns_roce_v1_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
>  		}
>
>  		wqe = get_send_wqe(qp, ind & (qp->sq.wqe_cnt - 1));
> +		if (unlikely(!wqe)) {
> +			dev_err(dev, "get send wqe failed\n");
> +			ret = -EINVAL;
> +			*bad_wr = wr;
> +			goto out;
> +		}
>  		qp->sq.wrid[(qp->sq.head + nreq) & (qp->sq.wqe_cnt - 1)] =
>  								      wr->wr_id;
>
> @@ -1558,6 +1564,11 @@ static int hns_roce_v1_poll_one(struct hns_roce_cq *hr_cq,
>  		sq_wqe = get_send_wqe(*cur_qp, roce_get_field(cqe->cqe_byte_4,
>  						CQE_BYTE_4_WQE_INDEX_M,
>  						CQE_BYTE_4_WQE_INDEX_S));
> +		if (unlikely(!sq_wqe)) {
> +			dev_err(dev, "Get send wqe failed!\n");
> +			return -EFAULT;
> +		}
> +
>  		switch (sq_wqe->flag & HNS_ROCE_WQE_OPCODE_MASK) {
>  		case HNS_ROCE_WQE_OPCODE_SEND:
>  			wc->opcode = IB_WC_SEND;
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--jesV4P1FjH8FXPjZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX16PZAAoJEORje4g2clinoyQP/32/J8JwKWOl4J3ggL+j4VmU
oPlr4u3yQ7ChIVWnALHBO23E8XtxBl0dgXhZlYbzx0v01ZbzanKIaVI81Hg63TzG
iYZvcmveemRablKMhgdyxbQh0jfrxVX9Ce4YVXZAOzbnIFkD/lvJ9E02K/w7YWeT
0hUnPnj+TA+bz+u4CP3BgbBvvGXBHECOMWZKFrmIXhcLTOUvNWN42iAkDwamJINj
Dacd6yeV+Wz/5rVgt9N0Cn7pkXo1qg/zDe7RohSSbv5nfEIt7GdFRMijKZORbXoY
OhLSnmfQJ5Q7CsELE3pYyOWpjXMQAc8na9rinsZZXtQB2tNIECHyM3zkWwA770ey
aaBRKfSGgCORo54kkFp0rlSowPFPxYSB051PoiJM/KEJL5D+mRPHN01ShYXUJxDE
YwSdt5tL19YUWxhfuE4Dh5ck0s59nZuFfIx4/WnUSBqKb8zs0Wvk3ZkWwGBx3eCY
P18YcbaYA2woiAc4Mbot4pQDJ1U//hhQ0oVX2ByK7M8m4oQkzG52YETWRO5cxN9X
mWBkdqlCH1ywBuwDr5IxQ75Ljb9LMI8SbOHeTMQ5jK9LXGLUDLHv6w7jdWpulnYC
fWV+YLPms0d5E9n4KGs5Dz1zL2mUSAYlY7Gm6FYVLjhkMgqmP3yVXTBZ2oxTJT0Q
3dGUfFe2exBBMbG6J3yp
=DSo6
-----END PGP SIGNATURE-----

--jesV4P1FjH8FXPjZ--
