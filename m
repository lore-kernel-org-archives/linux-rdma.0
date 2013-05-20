From: Jinpu Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: list corruption in IPOIB
Date: Mon, 20 May 2013 11:10:03 +0200
Message-ID: <CAMGffEn6YwXSB7KDfDRJrJmBaiQEG-zAjEonY=JUxMo=nLRSXQ@mail.gmail.com>
References: <519686B4.7010300@profitbricks.com> <CAJZOPZJNA7E005x9+XdVMG31fLEZm2mKB1nkpt5m3hA1qh7fYg@mail.gmail.com>
 <5197F447.5020702@profitbricks.com> <51986A8B.9030806@mellanox.com>
 <519898B0.1000901@profitbricks.com> <5199E747.3070502@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5199E747.3070502-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dongsu Park <dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

which list_del do you mean? in ipoib_cm_tx_start?

On Mon, May 20, 2013 at 11:05 AM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wr=
ote:
> On 19/05/2013 12:17, Jack Wang wrote:
>>
>> we added inject_bug sysfs node to make function run into error case,=
 like
>> something below. Yes, you are right, we want to speedup the bug repr=
oduce
>> process, and we saw the warning and come to conclusion the neigh->li=
st
>> corrupted some where. What's your opinion?
>
>
> Yes, for the synthetic experiment you made, there's a possible point =
here:
>
> Under the CM error flow (e.g your injected error), we delete a neighb=
our,
> but we also do it from the flow that flush neighbours (e.g when chang=
ing the
> device mode from UD to CM, as you did in your script). When this happ=
ens
> concurrently, these two code pieces call for deleting the neighbour f=
rom the
> list. So the spinlock might not be enough and we should have do
> list_del_init(&neigh->list) instead of list_del, helps?
>
> Or.



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
