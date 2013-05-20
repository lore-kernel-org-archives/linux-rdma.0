From: Jinpu Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: list corruption in IPOIB
Date: Mon, 20 May 2013 14:46:03 +0200
Message-ID: <CAMGffEk=PJge4jtdcx8xOKA_3RhcSn9wweULxCE7yctPApSn1g@mail.gmail.com>
References: <519686B4.7010300@profitbricks.com> <CAJZOPZJNA7E005x9+XdVMG31fLEZm2mKB1nkpt5m3hA1qh7fYg@mail.gmail.com>
 <5197F447.5020702@profitbricks.com> <51986A8B.9030806@mellanox.com>
 <519898B0.1000901@profitbricks.com> <5199E747.3070502@mellanox.com>
 <CAMGffEn6YwXSB7KDfDRJrJmBaiQEG-zAjEonY=JUxMo=nLRSXQ@mail.gmail.com> <519A01DD.6080906@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <519A01DD.6080906-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dongsu Park <dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

A quick test show the list_corruption warning is gone, after I convert
 all list_del(&neigh->list) to  list_del_list(&neigh->list).

Test is still running, will update status if anything wrong.

Thanks Or.



On Mon, May 20, 2013 at 12:58 PM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wr=
ote:
> On 20/05/2013 12:10, Jinpu Wang wrote:
>>
>> which list_del do you mean? in ipoib_cm_tx_start?
>
> yes, but not only, you can start with 5KG hammer and convert all thes=
ehits
> to list_del_init
>
> linux-2.6]# grep list_del drivers/infiniband/ulp/ipoib/*.c | grep nei=
gh
> drivers/infiniband/ulp/ipoib/ipoib_cm.c: list_del(&neigh->list);
> drivers/infiniband/ulp/ipoib/ipoib_cm.c: list_del(&neigh->list);
> drivers/infiniband/ulp/ipoib/ipoib_cm.c: list_del(&neigh->list);
> drivers/infiniband/ulp/ipoib/ipoib_main.c: list_del(&neigh->list);
> drivers/infiniband/ulp/ipoib/ipoib_main.c: list_del(&neigh->list);
> drivers/infiniband/ulp/ipoib/ipoib_main.c: list_del(&neigh->list);
> drivers/infiniband/ulp/ipoib/ipoib_main.c: list_del(&neigh->list);
> drivers/infiniband/ulp/ipoib/ipoib_main.c: list_del(&neigh->list);
> drivers/infiniband/ulp/ipoib/ipoib_main.c: list_del(&neigh->list);
>



--=20
Mit freundlichen Gr=FC=DFen,
Best Regards,

Jack Wang

Linux Kernel Developer Storage
ProfitBricks GmbH  The IaaS-Company.

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin
Tel: +49 30 6098 56991-308
=46ax: +49 30 6098 56992-203
Email: jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
URL: http://www.profitbricks.com

Sitz der Gesellschaft: Berlin.
Registergericht: Amtsgericht Charlottenburg, HRB 125506 B.
Gesch=E4ftsf=FChrer: Andreas Gauger, Achim Weiss.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
