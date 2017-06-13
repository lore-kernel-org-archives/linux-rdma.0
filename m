From: "Christian Benvenuti (benve)" <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v3 1/2] IB/usnic: Implement get_netdev hook
Date: Tue, 13 Jun 2017 07:56:09 +0000
Message-ID: <7a612530e43b4a42b4d3926a07ad4a70@XCH-RCD-017.cisco.com>
References: <20170611054450.7221-1-yuval.shaia@oracle.com>
 <20170611054450.7221-2-yuval.shaia@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170611054450.7221-2-yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org" <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, "devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org" <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, "somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org" <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, "sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org" <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, "Dave Goodell (dgoodell)" <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "sagi-TmH2Wj2nsNJBDLzU/O5InQ@public.gmane.org" <sagi-TmH2Wj2nsNJBDLzU/O5InQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> -----Original Message-----
> From: Yuval Shaia [mailto:yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org]
> Sent: Saturday, June 10, 2017 10:45 PM
> To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org; hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org;
> selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org; devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org;
> somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org; sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org; Christian
> Benvenuti (benve); Dave Goodell (dgoodell); monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org;
> leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org;
> dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org; sagi-TmH2Wj2nsNJBDLzU/O5InQ@public.gmane.org;
> bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org; yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org;
> linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: [PATCH v3 1/2] IB/usnic: Implement get_netdev hook
>=20
> usnic's get_netdev hook for struct ib_device is missing - add it.
>=20
> Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Reviewed-by: Christian Benvenuti <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
