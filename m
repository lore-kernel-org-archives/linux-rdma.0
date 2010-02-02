From: Ramachandra K <ariston-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: qlgc_vnic conflicts with Xen (was Re: Pull request for OFED 1.5)
Date: Tue, 2 Feb 2010 11:29:52 -0500
Message-ID: <71d336491002020829j136b6249r9438ebe60df9ca5a@mail.gmail.com>
References: <4B6765E7.4020900@oracle.com> <4B677723.9040508@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B677723.9040508-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Grover <andy.grover-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gary.leshner-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org, ramachandra.kuchimanchi-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Andy,

What is the kernel version you are using ? Is the Xen patch you
are referring to an out of tree patch ? And from an OFED perspective,
which OFED versions would be impacted ?

Regards,
Ram

On Mon, Feb 1, 2010 at 7:51 PM, Andy Grover <andy.grover-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wr=
ote:
> Actually the build error occurred on kernels with a recent Xen patch,
> because it also defines a struct mc_info. I suggest renaming your str=
uct
> mc_info to vnic_mc_info perhaps?
>
> Regards -- Andy
>
> Andy Grover wrote:
>> Hi Vlad,
>>
>> I found a small typo in the header guard of vnic_multicast.h which c=
an
>> cause a compilation error, please pull.
>>
>> Thanks -- Regards -- Andy
>>
>> The following changes since commit 40fbb82255896a5c39b35035e2fd52022=
46b6508:
>> =A0 Yevgeny Petrilin (1):
>> =A0 =A0 =A0 =A0 mlx4_en: No need to set smaller tx queue len
>>
>> are available in the git repository at:
>>
>> =A0 git://git.openfabrics.org/~agrover/ofed_1_5/linux-2.6.git
>> code-drop/20100201
>>
>> Andy Grover (1):
>> =A0 =A0 =A0 qlgc_vnic: Fix typo in header guard
>>
>> =A0drivers/infiniband/ulp/qlgc_vnic/vnic_multicast.h | =A0 =A02 +-
>> =A01 files changed, 1 insertions(+), 1 deletions(-)
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma=
" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
