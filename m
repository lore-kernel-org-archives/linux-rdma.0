From: Jinpu Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH] RDMA/cma: fix first byte overwritten for AF_IB
Date: Wed, 17 Dec 2014 12:58:09 +0100
Message-ID: <CAMGffEm=ONPMi5RxGRKef5WaOyUrDTZbOKOziJVexffG86MZ5w@mail.gmail.com>
References: <1418744596-25251-1-git-send-email-jinpu.wang@profitbricks.com> <54915D84.5000405@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54915D84.5000405-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Or,

We have some trouble in the past about IPoIB support about neighbour
discovery, AF_IB doesn't relay on IPoIB, so
we think have another option maybe give us more safe in some cases.



On Wed, Dec 17, 2014 at 11:40 AM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wr=
ote:
> On 12/16/2014 5:43 PM, Jack Wang wrote:
>>
>> If user attach private data for AF_IB,
>
>
> Just out of curiosity, can you share what was the motivation for you =
to use
> AF_IB?
>
>
> Or.
>
>
>> the first byte will
>> be overwritten, because we always set the cma version no matter
>> family is AF_IB, so move the version set inside if condition.
>
>



--=20
Mit freundlichen Gr=C3=BC=C3=9Fen,
Best Regards,

Jack Wang

Linux Kernel Developer Storage
ProfitBricks GmbH  The IaaS-Company.

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin
Tel: +49 30 5770083-42
=46ax: +49 30 5770085-98
Email: jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
URL: http://www.profitbricks.de

Sitz der Gesellschaft: Berlin.
Registergericht: Amtsgericht Charlottenburg, HRB 125506 B.
Gesch=C3=A4ftsf=C3=BChrer: Andreas Gauger, Achim Weiss.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
