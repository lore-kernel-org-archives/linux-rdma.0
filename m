From: "Parvi Kaustubhi (pkaustub)" <pkaustub@cisco.com>
Subject: Re: [PATCH 7/8] infiniband: usnic: no need to check return value of
 debugfs_create functions
Date: Wed, 23 Jan 2019 00:16:53 +0000
Message-ID: <A20ACC86-F6C9-4C38-8D63-535BB8CC42F9@cisco.com>
References: <20190122151800.15092-1-gregkh@linuxfoundation.org>
 <20190122151800.15092-8-gregkh@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190122151800.15092-8-gregkh@linuxfoundation.org>
Content-Language: en-US
Content-ID: <ECB2F791956F1D4A98417EA95093D4D1@emea.cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "Christian Benvenuti (benve)" <benve@cisco.com>, "Nelson Escobar (neescoba)" <neescoba@cisco.com>
List-Id: linux-rdma@vger.kernel.org

usnic driver was tested with this change.

Acked-by: Parvi Kaustubhi <pkaustub@cisco.com>

> On Jan 22, 2019, at 7:17 AM, Greg Kroah-Hartman <gregkh@linuxfoundation.o=
rg> wrote:
>=20
> When calling debugfs functions, there is no need to ever check the
> return value.  The function can work or not, but the code logic should
> never do something different based on this.
>=20
> Cc: Christian Benvenuti <benve@cisco.com>
> Cc: Nelson Escobar <neescoba@cisco.com>
> Cc: Parvi Kaustubhi <pkaustub@cisco.com>
> Cc: Doug Ledford <dledford@redhat.com>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: linux-rdma@vger.kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
> drivers/infiniband/hw/usnic/usnic_debugfs.c | 26 ---------------------
> 1 file changed, 26 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/usnic/usnic_debugfs.c b/drivers/infini=
band/hw/usnic/usnic_debugfs.c
> index a3115709fb03..e5a3f02fb078 100644
> --- a/drivers/infiniband/hw/usnic/usnic_debugfs.c
> +++ b/drivers/infiniband/hw/usnic/usnic_debugfs.c
> @@ -113,42 +113,21 @@ static const struct file_operations flowinfo_ops =
=3D {
> void usnic_debugfs_init(void)
> {
> 	debugfs_root =3D debugfs_create_dir(DRV_NAME, NULL);
> -	if (IS_ERR(debugfs_root)) {
> -		usnic_err("Failed to create debugfs root dir, check if debugfs is enab=
led in kernel configuration\n");
> -		goto out_clear_root;
> -	}
>=20
> 	flows_dentry =3D debugfs_create_dir("flows", debugfs_root);
> -	if (IS_ERR_OR_NULL(flows_dentry)) {
> -		usnic_err("Failed to create debugfs flow dir with err %ld\n",
> -				PTR_ERR(flows_dentry));
> -		goto out_free_root;
> -	}
>=20
> 	debugfs_create_file("build-info", S_IRUGO, debugfs_root,
> 				NULL, &usnic_debugfs_buildinfo_ops);
> -	return;
> -
> -out_free_root:
> -	debugfs_remove_recursive(debugfs_root);
> -out_clear_root:
> -	debugfs_root =3D NULL;
> }
>=20
> void usnic_debugfs_exit(void)
> {
> -	if (!debugfs_root)
> -		return;
> -
> 	debugfs_remove_recursive(debugfs_root);
> 	debugfs_root =3D NULL;
> }
>=20
> void usnic_debugfs_flow_add(struct usnic_ib_qp_grp_flow *qp_flow)
> {
> -	if (IS_ERR_OR_NULL(flows_dentry))
> -		return;
> -
> 	scnprintf(qp_flow->dentry_name, sizeof(qp_flow->dentry_name),
> 			"%u", qp_flow->flow->flow_id);
> 	qp_flow->dbgfs_dentry =3D debugfs_create_file(qp_flow->dentry_name,
> @@ -156,11 +135,6 @@ void usnic_debugfs_flow_add(struct usnic_ib_qp_grp_f=
low *qp_flow)
> 							flows_dentry,
> 							qp_flow,
> 							&flowinfo_ops);
> -	if (IS_ERR_OR_NULL(qp_flow->dbgfs_dentry)) {
> -		usnic_err("Failed to create dbg fs entry for flow %u with error %ld\n"=
,
> -				qp_flow->flow->flow_id,
> -				PTR_ERR(qp_flow->dbgfs_dentry));
> -	}
> }
>=20
> void usnic_debugfs_flow_remove(struct usnic_ib_qp_grp_flow *qp_flow)
> --=20
> 2.20.1
>=20
