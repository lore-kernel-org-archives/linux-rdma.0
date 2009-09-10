From: Ira Weiny <weiny2@llnl.gov>
Subject: Re: [ofa-general] Re: [PATCH v2] infiniband-diags/scripts: Add
	'ibcheckspeed' and 'ibcheckportspeed' to scripts
Date: Thu, 10 Sep 2009 09:02:13 -0700
Message-ID: <20090910090213.6888b7d5.weiny2@llnl.gov>
References: <829ded920909100602h78614ac0jd4eb1ee8d7a3779b@mail.gmail.com>
	<f0e08f230909100623k75d69e52m965628c3305f2125@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <general-bounces@lists.openfabrics.org>
In-Reply-To: <f0e08f230909100623k75d69e52m965628c3305f2125@mail.gmail.com>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general>,
	<mailto:general-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/general>
List-Post: <mailto:general@lists.openfabrics.org>
List-Help: <mailto:general-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general>,
	<mailto:general-request@lists.openfabrics.org?subject=subscribe>
Sender: general-bounces@lists.openfabrics.org
Errors-To: general-bounces@lists.openfabrics.org
To: Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: OFED mailing list <linux-rdma@vger.kernel.org>, Keshetti Mahesh <keshetti.mahesh@gmail.com>, OFED mailing list <general@lists.openfabrics.org>
List-Id: linux-rdma@vger.kernel.org

Also, iblinkinfo will report links which it finds capable of either faster or wider operation.  iblinkinfo checks both ends of the link as Hal mentions.  It reports this with output like.

Switch 0x0005ad0000092106 Cisco Switch SFS7000D:
...
           7    8[  ] ==( 4X 2.5 Gbps Active/  LinkUp)==>       8   12[  ] "MT47396 Infiniscale-III Mellanox Technologies" ( Could be 5.0 Gbps)
...

Also the portstatus console command in OpenSM will report links which are running at "reduced speed or width".  Although this does not check the remote port.

OpenSM $ help portstatus
portstatus [ca|switch|router]
summarize port status
   [ca|switch|router] -- limit the results to the node type specified
OpenSM $ portstatus
"ALL" port status:
   115 port(s) scanned on 9 nodes in 26 us
   85 down
   30 active
   32 at 4X
   22 at 2.5 Gbps
   8 at 5.0 Gbps
   2 at 10.0 Gbps

Possible issues:
   2 disabled
      0x0008f10400411b18 5 (ISR9024D Voltaire)
      0x0005ad0000092106 13 (Cisco Switch SFS7000D)
   6 with reduced speed
      0x0008f10500200220 33 (Voltaire 4036 - 36 QDR ports switch)
      0x0008f10500200220 19 (Voltaire 4036 - 36 QDR ports switch)
      0x0005ad0000092106 21 (Cisco Switch SFS7000D)
      0x0005ad0000092106 20 (Cisco Switch SFS7000D)
      0x0005ad0000092106 9 (Cisco Switch SFS7000D)
      0x0005ad0000092106 8 (Cisco Switch SFS7000D)


Ira

On Thu, 10 Sep 2009 09:23:35 -0400
Hal Rosenstock <hal.rosenstock@gmail.com> wrote:

> On Thu, Sep 10, 2009 at 9:02 AM, Keshetti Mahesh
> <keshetti.mahesh@gmail.com>wrote:
> 
> > Added 'ibcheckspeed' and 'ibcheckportspeed': Similar to
> > 'ibcheckwidth/ibcheckportwidth' in functionality and implementation.
> > Reports error/warning messages if the LinkSpeedActive is configured as
> > 2.5 Gbps when the LinkSpeedSupported is more than 2.5 Gbps.
> >
> 
> ibportstate checks for more than this in terms of speed (and width)
> anomalies.
> 
> Would it be better for these scripts to use that tool now ? Alternatively,
> the additional speed/width anomaly checks could be implemented in these
> scripts but it does involve checking the peer port so there's a little more
> to it.
> 
> -- Hal
> 
> 
> >
> > Signed-off-by: Keshetti Mahesh < keshetti.mahesh@gmail.com>
> > ---
> >  infiniband-diags/scripts/ibcheckportspeed.in |  146
> > ++++++++++++++++++++++++++
> >  infiniband-diags/scripts/ibcheckportwidth.in |    2 +-
> >  infiniband-diags/scripts/ibcheckspeed.in     |  135
> > ++++++++++++++++++++++++
> >  3 files changed, 282 insertions(+), 1 deletions(-)
> >  create mode 100644 infiniband-diags/scripts/ibcheckportspeed.in
> >  create mode 100644 infiniband-diags/scripts/ibcheckspeed.in
> >
> <snip...>
> 


-- 
Ira Weiny
Math Programmer/Computer Scientist
Lawrence Livermore National Lab
925-423-8008
weiny2@llnl.gov
