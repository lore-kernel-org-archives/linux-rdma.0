From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH for-next 10/20] IB/hns: Modify the init of iboe lock
Date: Tue, 13 Sep 2016 09:50:28 +0300
Message-ID: <20160913065028.GR8812@leon.nu>
References: <1473417051-99560-1-git-send-email-salil.mehta@huawei.com>
 <1473417051-99560-11-git-send-email-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="brdEIFGMNIjz5YJG"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1473417051-99560-11-git-send-email-salil.mehta@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Salil Mehta <salil.mehta@huawei.com>
Cc: dledford@redhat.com, xavier.huwei@huawei.com, oulijun@huawei.com, yisen.zhuang@huawei.com, xuwei5@hisilicon.com, mehta.salil.lnk@gmail.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, linuxarm@huawei.com, "Dongdong Huang(Donald)" <hdd.huang@huawei.com>
List-Id: linux-rdma@vger.kernel.org


--brdEIFGMNIjz5YJG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 09, 2016 at 06:30:41PM +0800, Salil Mehta wrote:
> From: Lijun Ou <oulijun@huawei.com>
>
> This lock will be used in query port interface, and will be called
> while IB device was registered to OFED frame. So, the lock of iboe
> must be initiated before IB device was registered.

Sorry,
what did you mean by writing "OFED frame"?

>
> Signed-off-by: Lijun Ou <oulijun@huawei.com>
> Signed-off-by: Dongdong Huang(Donald) <hdd.huang@huawei.com>
> Reviewed-by:  Wei Hu (Xavier) <xavier.huwei@huawei.com>
> Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
> ---
>  drivers/infiniband/hw/hns/hns_roce_main.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c b/drivers/infiniband/hw/hns/hns_roce_main.c
> index 2704076..4721c0c 100644
> --- a/drivers/infiniband/hw/hns/hns_roce_main.c
> +++ b/drivers/infiniband/hw/hns/hns_roce_main.c
> @@ -615,6 +615,7 @@ static int hns_roce_register_device(struct hns_roce_dev *hr_dev)
>  	struct device *dev = &hr_dev->pdev->dev;
>
>  	iboe = &hr_dev->iboe;
> +	spin_lock_init(&iboe->lock);
>
>  	ib_dev = &hr_dev->ib_dev;
>  	strlcpy(ib_dev->name, "hisi_%d", IB_DEVICE_NAME_MAX);
> @@ -701,8 +702,6 @@ static int hns_roce_register_device(struct hns_roce_dev *hr_dev)
>  		goto error_failed_setup_mtu_gids;
>  	}
>
> -	spin_lock_init(&iboe->lock);
> -
>  	iboe->nb.notifier_call = hns_roce_netdev_event;
>  	ret = register_netdevice_notifier(&iboe->nb);
>  	if (ret) {
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--brdEIFGMNIjz5YJG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX16G0AAoJEORje4g2clinxTgP/1PjXECghV9YpnBkDwDTr148
2N/VY9w3hM3zX2FVvyyuOcOG2jMlqIjLP2ylnYzmVv1jer8eo2wQystMpC8UVYui
IghuP9HZISPNuc+NV67ZypPcAOmUkLvJLbV0YVKNHWAKl25lFVFQ68pezJ4fI5En
TLaoUwFlEgvWD8pGnpHh7qQZyLu1M3MNA5HJsAcHU8vARknjkmJ2VwblTV2APXgL
XneULl9PmEkpvFX0Ph2AKHoIqPtyYJAwqGPB3WmQR8+rzN5Ws4n1UNp4mLjlHnPX
6UKKhGk6VBP+Tgacb6IJdFFs9OIAtIBYibOH5GLt7HSSMb9qY+B+uspD/+TjEStH
OiR9saFBcwpQybu6wGOZMeslCUXlHRxGzqgvAkHqal/YsIqTs0ykN/zmxS60xmge
8Dt+iT8QhMqciPCNtzJQTjCxjo32WJzlSIbrMSJrNzReQDJe5BUhj48XytDB+b08
cxKHfqwQlQNHUPPy+aRVsB7vQwnqjnWPtWwn7FC8kppzexbjBBPRjmtqM/weCUvD
+JPKsjpRFNRFUMg7XoycTciDQNrVq6ctMrWjjCGsF0F/Odgbww4F3UO/8hMup9Vh
mp/ls727IRX0hWlDrrKmLoloESk8eLjsq/A5sra0fe6zQEJL9EJURzQ0iUJnqDon
8TonGw1Y57jv4RBFYXHl
=Q5WF
-----END PGP SIGNATURE-----

--brdEIFGMNIjz5YJG--
