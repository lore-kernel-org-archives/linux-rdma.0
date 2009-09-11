From: Keshetti Mahesh <keshetti.mahesh@gmail.com>
Subject: Re: [ofa-general] Re: [PATCH v2] infiniband-diags/scripts: Add
	'ibcheckspeed' and 'ibcheckportspeed' to scripts
Date: Fri, 11 Sep 2009 09:32:39 +0530
Message-ID: <829ded920909102102o49f037cbhc53a849f1fcfdaa4@mail.gmail.com>
References: <829ded920909100602h78614ac0jd4eb1ee8d7a3779b@mail.gmail.com>
	<f0e08f230909100623k75d69e52m965628c3305f2125@mail.gmail.com>
	<20090910090213.6888b7d5.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <general-bounces@lists.openfabrics.org>
In-Reply-To: <20090910090213.6888b7d5.weiny2@llnl.gov>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general>,
	<mailto:general-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/general>
List-Post: <mailto:general@lists.openfabrics.org>
List-Help: <mailto:general-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general>,
	<mailto:general-request@lists.openfabrics.org?subject=subscribe>
Sender: general-bounces@lists.openfabrics.org
Errors-To: general-bounces@lists.openfabrics.org
To: Ira Weiny <weiny2@llnl.gov>
Cc: OFED mailing list <linux-rdma@vger.kernel.org>, OFED mailing list <general@lists.openfabrics.org>
List-Id: linux-rdma@vger.kernel.org

My badness. I have not used 'iblinkinfo' before.
So, I guess there is no need for the above script. Apart from that, I feel
there should be a program/script which will first scan the fabric to find t=
he
maximum common supported width/speed and then report the warning messages
of the links/ports which are configured with active width/speed less
than the found
value. Is there any tool already exists which does the same ?

-
Keshetti Mahesh

On Thu, Sep 10, 2009 at 9:32 PM, Ira Weiny <weiny2@llnl.gov> wrote:
> Also, iblinkinfo will report links which it finds capable of either faste=
r or wider operation. =A0iblinkinfo checks both ends of the link as Hal men=
tions. =A0It reports this with output like.
>
> Switch 0x0005ad0000092106 Cisco Switch SFS7000D:
> ...
> =A0 =A0 =A0 =A0 =A0 7 =A0 =A08[ =A0] =3D=3D( 4X 2.5 Gbps Active/ =A0LinkU=
p)=3D=3D> =A0 =A0 =A0 8 =A0 12[ =A0] "MT47396 Infiniscale-III Mellanox Tech=
nologies" ( Could be 5.0 Gbps)
> ...
>
> Also the portstatus console command in OpenSM will report links which are=
 running at "reduced speed or width". =A0Although this does not check the r=
emote port.
>
> OpenSM $ help portstatus
> portstatus [ca|switch|router]
> summarize port status
> =A0 [ca|switch|router] -- limit the results to the node type specified
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
> =A0 =A0 =A00x0008f10500200220 33 (Voltaire 4036 - 36 QDR ports switch)
> =A0 =A0 =A00x0008f10500200220 19 (Voltaire 4036 - 36 QDR ports switch)
> =A0 =A0 =A00x0005ad0000092106 21 (Cisco Switch SFS7000D)
> =A0 =A0 =A00x0005ad0000092106 20 (Cisco Switch SFS7000D)
> =A0 =A0 =A00x0005ad0000092106 9 (Cisco Switch SFS7000D)
> =A0 =A0 =A00x0005ad0000092106 8 (Cisco Switch SFS7000D)
>
>
> Ira
>
> On Thu, 10 Sep 2009 09:23:35 -0400
> Hal Rosenstock <hal.rosenstock@gmail.com> wrote:
>
>> On Thu, Sep 10, 2009 at 9:02 AM, Keshetti Mahesh
>> <keshetti.mahesh@gmail.com>wrote:
>>
>> > Added 'ibcheckspeed' and 'ibcheckportspeed': Similar to
>> > 'ibcheckwidth/ibcheckportwidth' in functionality and implementation.
>> > Reports error/warning messages if the LinkSpeedActive is configured as
>> > 2.5 Gbps when the LinkSpeedSupported is more than 2.5 Gbps.
>> >
>>
>> ibportstate checks for more than this in terms of speed (and width)
>> anomalies.
>>
>> Would it be better for these scripts to use that tool now ? Alternativel=
y,
>> the additional speed/width anomaly checks could be implemented in these
>> scripts but it does involve checking the peer port so there's a little m=
ore
>> to it.
>>
>> -- Hal
>>
>>
>> >
>> > Signed-off-by: Keshetti Mahesh < keshetti.mahesh@gmail.com>
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
> weiny2@llnl.gov
>
