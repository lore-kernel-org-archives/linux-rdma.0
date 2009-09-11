From: Barry Mavin <Barry.Mavin@recital.com>
Subject: Re: [ofa-general] Re: [PATCH v2] infiniband-diags/scripts: Add
	'ibcheckspeed' and 'ibcheckportspeed' to scripts
Date: Fri, 11 Sep 2009 11:08:15 +0530
Message-ID: <C6CFE01F.1561C%Barry.Mavin@recital.com>
References: <829ded920909102102o49f037cbhc53a849f1fcfdaa4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <general-bounces@lists.openfabrics.org>
In-Reply-To: <829ded920909102102o49f037cbhc53a849f1fcfdaa4@mail.gmail.com>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general>,
	<mailto:general-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/general>
List-Post: <mailto:general@lists.openfabrics.org>
List-Help: <mailto:general-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general>,
	<mailto:general-request@lists.openfabrics.org?subject=subscribe>
Sender: general-bounces@lists.openfabrics.org
Errors-To: general-bounces@lists.openfabrics.org
To: OFED mailing list <general@lists.openfabrics.org>
Cc: OFED mailing list <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

I use mellanox connectx cards and switches in a cluster.

When I try and use ibtracert I get this output.

# ibtracert 10.10.10.1 10.10.10.3
ibwarn: [6998] _do_madrpc: recv failed: Connection timed out
ibwarn: [6998] mad_rpc: _do_madrpc failed; dport (Lid 10)
ibwarn: [6998] find_route: can't reach to/from ports
ibtracert: iberror: failed: can't find a route to the src port

Does anyone have any idea why this would be happening?

---
Regards
Barry Mavin
Recital Corporation



> From: Keshetti Mahesh <keshetti.mahesh@gmail.com>
> Date: Fri, 11 Sep 2009 09:32:39 +0530
> To: Ira Weiny <weiny2@llnl.gov>
> Cc: OFED mailing list <linux-rdma@vger.kernel.org>, OFED mailing list
> <general@lists.openfabrics.org>
> Subject: Re: [ofa-general] Re: [PATCH v2] infiniband-diags/scripts: Add
> 'ibcheckspeed' and 'ibcheckportspeed' to scripts
>=20
> My badness. I have not used 'iblinkinfo' before.
> So, I guess there is no need for the above script. Apart from that, I fee=
l
> there should be a program/script which will first scan the fabric to find=
 the
> maximum common supported width/speed and then report the warning messages
> of the links/ports which are configured with active width/speed less
> than the found
> value. Is there any tool already exists which does the same ?
>=20
> -
> Keshetti Mahesh
>=20
> On Thu, Sep 10, 2009 at 9:32 PM, Ira Weiny <weiny2@llnl.gov> wrote:
>> Also, iblinkinfo will report links which it finds capable of either fast=
er or
>> wider operation. =A0iblinkinfo checks both ends of the link as Hal mention=
s.
>> =A0It reports this with output like.
>>=20
>> Switch 0x0005ad0000092106 Cisco Switch SFS7000D:
>> ...
>> =A0 =A0 =A0 =A0 =A0 7 =A0 =A08[ =A0] =3D=3D( 4X 2.5 Gbps Active/ =A0LinkUp)=3D=3D> =A0 =A0 =A0 8 =A0 12[ =A0=
]
>> "MT47396 Infiniscale-III Mellanox Technologies" ( Could be 5.0 Gbps)
>> ...
>>=20
>> Also the portstatus console command in OpenSM will report links which ar=
e
>> running at "reduced speed or width". =A0Although this does not check the r=
emote
>> port.
>>=20
>> OpenSM $ help portstatus
>> portstatus [ca|switch|router]
>> summarize port status
>> =A0 [ca|switch|router] -- limit the results to the node type specified
>> OpenSM $ portstatus
>> "ALL" port status:
>> =A0 115 port(s) scanned on 9 nodes in 26 us
>> =A0 85 down
>> =A0 30 active
>> =A0 32 at 4X
>> =A0 22 at 2.5 Gbps
>> =A0 8 at 5.0 Gbps
>> =A0 2 at 10.0 Gbps
>>=20
>> Possible issues:
>> =A0 2 disabled
>> =A0 =A0 =A00x0008f10400411b18 5 (ISR9024D Voltaire)
>> =A0 =A0 =A00x0005ad0000092106 13 (Cisco Switch SFS7000D)
>> =A0 6 with reduced speed
>> =A0 =A0 =A00x0008f10500200220 33 (Voltaire 4036 - 36 QDR ports switch)
>> =A0 =A0 =A00x0008f10500200220 19 (Voltaire 4036 - 36 QDR ports switch)
>> =A0 =A0 =A00x0005ad0000092106 21 (Cisco Switch SFS7000D)
>> =A0 =A0 =A00x0005ad0000092106 20 (Cisco Switch SFS7000D)
>> =A0 =A0 =A00x0005ad0000092106 9 (Cisco Switch SFS7000D)
>> =A0 =A0 =A00x0005ad0000092106 8 (Cisco Switch SFS7000D)
>>=20
>>=20
>> Ira
>>=20
>> On Thu, 10 Sep 2009 09:23:35 -0400
>> Hal Rosenstock <hal.rosenstock@gmail.com> wrote:
>>=20
>>> On Thu, Sep 10, 2009 at 9:02 AM, Keshetti Mahesh
>>> <keshetti.mahesh@gmail.com>wrote:
>>>=20
>>>> Added 'ibcheckspeed' and 'ibcheckportspeed': Similar to
>>>> 'ibcheckwidth/ibcheckportwidth' in functionality and implementation.
>>>> Reports error/warning messages if the LinkSpeedActive is configured as
>>>> 2.5 Gbps when the LinkSpeedSupported is more than 2.5 Gbps.
>>>>=20
>>>=20
>>> ibportstate checks for more than this in terms of speed (and width)
>>> anomalies.
>>>=20
>>> Would it be better for these scripts to use that tool now ? Alternative=
ly,
>>> the additional speed/width anomaly checks could be implemented in these
>>> scripts but it does involve checking the peer port so there's a little =
more
>>> to it.
>>>=20
>>> -- Hal
>>>=20
>>>=20
>>>>=20
>>>> Signed-off-by: Keshetti Mahesh < keshetti.mahesh@gmail.com>
>>>> ---
>>>> =A0infiniband-diags/scripts/ibcheckportspeed.in | =A0146
>>>> ++++++++++++++++++++++++++
>>>> =A0infiniband-diags/scripts/ibcheckportwidth.in | =A0 =A02 +-
>>>> =A0infiniband-diags/scripts/ibcheckspeed.in =A0 =A0 | =A0135
>>>> ++++++++++++++++++++++++
>>>> =A03 files changed, 282 insertions(+), 1 deletions(-)
>>>> =A0create mode 100644 infiniband-diags/scripts/ibcheckportspeed.in
>>>> =A0create mode 100644 infiniband-diags/scripts/ibcheckspeed.in
>>>>=20
>>> <snip...>
>>>=20
>>=20
>>=20
>> --
>> Ira Weiny
>> Math Programmer/Computer Scientist
>> Lawrence Livermore National Lab
>> 925-423-8008
>> weiny2@llnl.gov
>>=20
> _______________________________________________
> general mailing list
> general@lists.openfabrics.org
> http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general
>=20
> To unsubscribe, please visit http://openib.org/mailman/listinfo/openib-ge=
neral
