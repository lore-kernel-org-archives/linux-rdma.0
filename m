From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [for-next 2/5] RDMA/bnxt_re: Add support for query firmware
 version
Date: Tue, 9 Jan 2018 16:18:53 +0200
Message-ID: <20180109141853.GG6823@mtr-leonro.local>
References: <1515152434-13105-1-git-send-email-devesh.sharma@broadcom.com>
 <1515152434-13105-3-git-send-email-devesh.sharma@broadcom.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="/Zw+/jwnNHcBRYYu"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1515152434-13105-3-git-send-email-devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--/Zw+/jwnNHcBRYYu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 05, 2018 at 06:40:31AM -0500, Devesh Sharma wrote:
> From: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
>
> The device now reports firmware version thus, removing
> the hard coded values of the FW version string and
> redundant fw_rev hook from sysfs. Adding code to query
> firmware version from underlying device and report it
> through the kernel verb to get firmware version string.
>
> Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/hw/bnxt_re/ib_verbs.c   | 14 ++++++++++++--
>  drivers/infiniband/hw/bnxt_re/ib_verbs.h   |  1 +
>  drivers/infiniband/hw/bnxt_re/main.c       | 11 +----------
>  drivers/infiniband/hw/bnxt_re/qplib_rcfw.c |  3 ++-
>  drivers/infiniband/hw/bnxt_re/qplib_sp.c   | 25 ++++++++++++++++++++++++-
>  drivers/infiniband/hw/bnxt_re/qplib_sp.h   |  3 ++-
>  6 files changed, 42 insertions(+), 15 deletions(-)
>
> diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> index 6dd2fe1..8a80e95 100644
> --- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> +++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> @@ -141,8 +141,9 @@ int bnxt_re_query_device(struct ib_device *ibdev,
>  	struct bnxt_qplib_dev_attr *dev_attr = &rdev->dev_attr;
>
>  	memset(ib_attr, 0, sizeof(*ib_attr));
> -
> -	ib_attr->fw_ver = (u64)(unsigned long)(dev_attr->fw_ver);
> +	memcpy(&ib_attr->fw_ver, dev_attr->fw_ver,
> +	       min(sizeof(dev_attr->fw_ver),
> +		   sizeof(ib_attr->fw_ver)));
>  	bnxt_qplib_get_guid(rdev->netdev->dev_addr,
>  			    (u8 *)&ib_attr->sys_image_guid);
>  	ib_attr->max_mr_size = BNXT_RE_MAX_MR_SIZE;
> @@ -281,6 +282,15 @@ int bnxt_re_get_port_immutable(struct ib_device *ibdev, u8 port_num,
>  	return 0;
>  }
>
> +void bnxt_re_query_fw_str(struct ib_device *ibdev, char *str)
> +{
> +	struct bnxt_re_dev *rdev = to_bnxt_re_dev(ibdev, ibdev);
> +
> +	snprintf(str, IB_FW_VERSION_NAME_MAX, "%d.%d.%d.%d",
> +		 rdev->dev_attr.fw_ver[0], rdev->dev_attr.fw_ver[1],
> +		 rdev->dev_attr.fw_ver[2], rdev->dev_attr.fw_ver[3]);
> +}
> +
>  int bnxt_re_query_pkey(struct ib_device *ibdev, u8 port_num,
>  		       u16 index, u16 *pkey)
>  {
> diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.h b/drivers/infiniband/hw/bnxt_re/ib_verbs.h
> index 1df11ed2..66dd8d2 100644
> --- a/drivers/infiniband/hw/bnxt_re/ib_verbs.h
> +++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.h
> @@ -143,6 +143,7 @@ int bnxt_re_query_port(struct ib_device *ibdev, u8 port_num,
>  		       struct ib_port_attr *port_attr);
>  int bnxt_re_get_port_immutable(struct ib_device *ibdev, u8 port_num,
>  			       struct ib_port_immutable *immutable);
> +void bnxt_re_query_fw_str(struct ib_device *ibdev, char *str);
>  int bnxt_re_query_pkey(struct ib_device *ibdev, u8 port_num,
>  		       u16 index, u16 *pkey);
>  int bnxt_re_del_gid(struct ib_device *ibdev, u8 port_num,
> diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw/bnxt_re/main.c
> index d825df0..38a5d4b 100644
> --- a/drivers/infiniband/hw/bnxt_re/main.c
> +++ b/drivers/infiniband/hw/bnxt_re/main.c
> @@ -572,6 +572,7 @@ static int bnxt_re_register_ib(struct bnxt_re_dev *rdev)
>
>  	ibdev->query_port		= bnxt_re_query_port;
>  	ibdev->get_port_immutable	= bnxt_re_get_port_immutable;
> +	ibdev->get_dev_fw_str           = bnxt_re_query_fw_str;
>  	ibdev->query_pkey		= bnxt_re_query_pkey;
>  	ibdev->query_gid		= bnxt_re_query_gid;
>  	ibdev->get_netdev		= bnxt_re_get_netdev;
> @@ -623,14 +624,6 @@ static ssize_t show_rev(struct device *device, struct device_attribute *attr,
>  	return scnprintf(buf, PAGE_SIZE, "0x%x\n", rdev->en_dev->pdev->vendor);
>  }
>
> -static ssize_t show_fw_ver(struct device *device, struct device_attribute *attr,
> -			   char *buf)
> -{
> -	struct bnxt_re_dev *rdev = to_bnxt_re_dev(device, ibdev.dev);
> -
> -	return scnprintf(buf, PAGE_SIZE, "%s\n", rdev->dev_attr.fw_ver);
> -}
> -
>  static ssize_t show_hca(struct device *device, struct device_attribute *attr,
>  			char *buf)
>  {
> @@ -640,12 +633,10 @@ static ssize_t show_hca(struct device *device, struct device_attribute *attr,
>  }
>
>  static DEVICE_ATTR(hw_rev, 0444, show_rev, NULL);
> -static DEVICE_ATTR(fw_rev, 0444, show_fw_ver, NULL);
>  static DEVICE_ATTR(hca_type, 0444, show_hca, NULL);
>
>  static struct device_attribute *bnxt_re_attributes[] = {
>  	&dev_attr_hw_rev,
> -	&dev_attr_fw_rev,
>  	&dev_attr_hca_type
>  };
>
> diff --git a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
> index bb5574a..6a3633a 100644
> --- a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
> +++ b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
> @@ -93,7 +93,8 @@ static int __send_message(struct bnxt_qplib_rcfw *rcfw, struct cmdq_base *req,
>  	opcode = req->opcode;
>  	if (!test_bit(FIRMWARE_INITIALIZED_FLAG, &rcfw->flags) &&
>  	    (opcode != CMDQ_BASE_OPCODE_QUERY_FUNC &&
> -	     opcode != CMDQ_BASE_OPCODE_INITIALIZE_FW)) {
> +	     opcode != CMDQ_BASE_OPCODE_INITIALIZE_FW &&
> +	     opcode != CMDQ_BASE_OPCODE_QUERY_VERSION)) {
>  		dev_err(&rcfw->pdev->dev,
>  			"QPLIB: RCFW not initialized, reject opcode 0x%x",
>  			opcode);
> diff --git a/drivers/infiniband/hw/bnxt_re/qplib_sp.c b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
> index f5450b7..60377a3 100644
> --- a/drivers/infiniband/hw/bnxt_re/qplib_sp.c
> +++ b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
> @@ -64,6 +64,29 @@ static bool bnxt_qplib_is_atomic_cap(struct bnxt_qplib_rcfw *rcfw)
>  	return !!(pcie_ctl2 & PCI_EXP_DEVCTL2_ATOMIC_REQ);
>  }
>
> +static void bnxt_qplib_query_version(struct bnxt_qplib_rcfw *rcfw,
> +				     char *fw_ver)
> +{
> +	struct cmdq_query_version req;
> +	struct creq_query_version_resp resp;
> +	u16 cmd_flags = 0;
> +	int rc = 0;
> +
> +	RCFW_CMD_PREP(req, QUERY_VERSION, cmd_flags);
> +
> +	rc = bnxt_qplib_rcfw_send_message(rcfw, (void *)&req,
> +					  (void *)&resp, NULL, 0);
> +	if (rc) {
> +		dev_err(&rcfw->pdev->dev, "QPLIB: Failed to query version");
> +		return;
> +	}

What will be the result on old FW and new kernel? Will it print error and fail?

> +
> +	fw_ver[0] = resp.fw_maj;
> +	fw_ver[1] = resp.fw_minor;
> +	fw_ver[2] = resp.fw_bld;
> +	fw_ver[3] = resp.fw_rsvd;
> +}
> +

Thanks

--/Zw+/jwnNHcBRYYu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpUz00ACgkQ5GN7iDZy
WKfuEA/8DDThMFbOqgvzKfsHx6e0aMVwKgPAMVTfDshoqw49tBAUxXslRQzrLO0I
3WPNwYykW1C6ZxOvw4p9+q5w6/l+iz8dk6V68p5rQAz2gycn3kUxXBAN8CrWE9Ut
vUAE02GsxTH+p3qWYlNVRXXeFC5WIaPtdYrKYG0Sn+hNs0R268i1K3OSvD5V2Sgs
HSp7QRhdMyiFMMojzxInzwaBQ2OLjbiA+rrTdDcyDyvEnTcbT/ICRLWdnkOpxtXy
4zMCPrbLwl7KLKIjfBOFXkL9kFn8iCLOBffnT1b5piJM1A0z5IQ8r1IgHFOVn3fO
VnRHKst6KgzDzYO/OaTPQJEQB/q2P7vVvAmRArUrticYAn3M1cDtaeUK/qpTLcQG
+XWgkVbfxhSzTFTRFjNoNCG2IvO5ei3nNDHeofTa5KBwFHcWv4HfFeIA3YWOv6Nk
f5+ANaQkf5r7xr2Zr9Lj+FDVC2imhaYfqoAbIo9G0YZX+dveUuOy/oqb9IewNogo
CRhQfwUVrWKPbRZdplzx1QZ4l4qbU/DLNT9LuIq7Qx26NwUCQlqfXF43UdD0Ip1o
DlsbKJ+4LRlodExXNq7WbPDlBiXKIegkaxmwg3trK2cDu5Yvl5SesYHmOGvVmBnL
w4X8pGFs+04rx+WxUFuEQj4EUASsjP/WXXFFQgYa91v8fv497Hg=
=GHgV
-----END PGP SIGNATURE-----

--/Zw+/jwnNHcBRYYu--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
