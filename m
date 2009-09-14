From: Keshetti Mahesh <keshetti.mahesh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [ofa-general] Re: [PATCH v2] infiniband-diags/scripts: Add
	'ibcheckspeed' and 'ibcheckportspeed' to scripts
Date: Mon, 14 Sep 2009 11:50:33 +0530
Message-ID: <829ded920909132320m7e33d79cx959fba7e6addb513@mail.gmail.com>
References: <829ded920909100602h78614ac0jd4eb1ee8d7a3779b@mail.gmail.com>
	<f0e08f230909100623k75d69e52m965628c3305f2125@mail.gmail.com>
	<20090910090213.6888b7d5.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20090910090213.6888b7d5.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, OFED mailing list <general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I have a small question. If there are all 5 Gbps (maximum supported
speed) ports
except one with 10 Gbps in a subnet then what is the expected behavior
of OpenSM
while setting active link speed ? Does OpenSM force the port with 10
Gbps to operate
at 5 Gbps or not ?

--
Keshetti Mahesh

On Thu, Sep 10, 2009 at 9:32 PM, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org> wrote:
> Also, iblinkinfo will report links which it finds capable of either f=
aster or wider operation. =A0iblinkinfo checks both ends of the link as=
 Hal mentions. =A0It reports this with output like.
>
> Switch 0x0005ad0000092106 Cisco Switch SFS7000D:
> ...
> =A0 =A0 =A0 =A0 =A0 7 =A0 =A08[ =A0] =3D=3D( 4X 2.5 Gbps Active/ =A0L=
inkUp)=3D=3D> =A0 =A0 =A0 8 =A0 12[ =A0] "MT47396 Infiniscale-III Mella=
nox Technologies" ( Could be 5.0 Gbps)
> ...
>
> Also the portstatus console command in OpenSM will report links which=
 are running at "reduced speed or width". =A0Although this does not che=
ck the remote port.
>
> OpenSM $ help portstatus
> portstatus [ca|switch|router]
> summarize port status
> =A0 [ca|switch|router] -- limit the results to the node type specifie=
d
> OpenSM $ portstatus
> "ALL" port status:
> =A0 115 port(s) scanned on 9 nodes in 26 us
> =A0 85 down
> =A0 30 active
> =A0 32 at 4X
> =A0 22 at 2.5 Gbps
> =A0 8 at 5.0 Gbps
> =A0 2 at 10.0 Gbps
>
> Possible issues:
> =A0 2 disabled
> =A0 =A0 =A00x0008f10400411b18 5 (ISR9024D Voltaire)
> =A0 =A0 =A00x0005ad0000092106 13 (Cisco Switch SFS7000D)
> =A0 6 with reduced speed
> =A0 =A0 =A00x0008f10500200220 33 (Voltaire 4036 - 36 QDR ports switch=
)
> =A0 =A0 =A00x0008f10500200220 19 (Voltaire 4036 - 36 QDR ports switch=
)
> =A0 =A0 =A00x0005ad0000092106 21 (Cisco Switch SFS7000D)
> =A0 =A0 =A00x0005ad0000092106 20 (Cisco Switch SFS7000D)
> =A0 =A0 =A00x0005ad0000092106 9 (Cisco Switch SFS7000D)
> =A0 =A0 =A00x0005ad0000092106 8 (Cisco Switch SFS7000D)
>
>
> Ira
>
> On Thu, 10 Sep 2009 09:23:35 -0400
> Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> On Thu, Sep 10, 2009 at 9:02 AM, Keshetti Mahesh
>> <keshetti.mahesh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>wrote:
>>
>> > Added 'ibcheckspeed' and 'ibcheckportspeed': Similar to
>> > 'ibcheckwidth/ibcheckportwidth' in functionality and implementatio=
n.
>> > Reports error/warning messages if the LinkSpeedActive is configure=
d as
>> > 2.5 Gbps when the LinkSpeedSupported is more than 2.5 Gbps.
>> >
>>
>> ibportstate checks for more than this in terms of speed (and width)
>> anomalies.
>>
>> Would it be better for these scripts to use that tool now ? Alternat=
ively,
>> the additional speed/width anomaly checks could be implemented in th=
ese
>> scripts but it does involve checking the peer port so there's a litt=
le more
>> to it.
>>
>> -- Hal
>>
>>
>> >
>> > Signed-off-by: Keshetti Mahesh < keshetti.mahesh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> > ---
>> > =A0infiniband-diags/scripts/ibcheckportspeed.in | =A0146
>> > ++++++++++++++++++++++++++
>> > =A0infiniband-diags/scripts/ibcheckportwidth.in | =A0 =A02 +-
>> > =A0infiniband-diags/scripts/ibcheckspeed.in =A0 =A0 | =A0135
>> > ++++++++++++++++++++++++
>> > =A03 files changed, 282 insertions(+), 1 deletions(-)
>> > =A0create mode 100644 infiniband-diags/scripts/ibcheckportspeed.in
>> > =A0create mode 100644 infiniband-diags/scripts/ibcheckspeed.in
>> >
>> <snip...>
>>
>
>
> --
> Ira Weiny
> Math Programmer/Computer Scientist
> Lawrence Livermore National Lab
> 925-423-8008
> weiny2-i2BcT+NCU+M@public.gmane.org
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
