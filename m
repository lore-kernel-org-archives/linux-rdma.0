From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH][MINOR] opensm/osm_sa_mcmember_record.c: Return proper
 scope for query with valid SA key
Date: Sun, 20 Jan 2013 12:12:39 +0200
Message-ID: <20130120101239.GC14190@calypso.mtl.com>
References: <50F06924.8070005@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <50F06924.8070005-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Hal,

On 14:33 Fri 11 Jan     , Hal Rosenstock wrote:
> 
> Rather than return Scope 2, Scope 0 is returned when SA MCMemberRecord queried with valid SA key.
> 
> saquery MCMR --mlid 0xc000
> MCMember Record dump:
> MGID....................ff12:401b:ffff::ffff:ffff
> PortGid.................::
> qkey....................0xb1b
> mlid....................0xc000
> mtu.....................0x84
> TClass..................0x0
> pkey....................0xffff
> rate....................0x83
> pkt_life................0x92
> SL......................0x0
> FlowLabel...............0x0
> HopLimit................0x0
> Scope...................0x2
> JoinState...............0x0
> ProxyJoin...............0x0
> 
> saquery MCMR --mlid 0xc000 --smkey 1
> MCMember Record dump:
> MGID....................ff12:401b:ffff::ffff:ffff
> PortGid.................fe80::8:f104:39a:169
> qkey....................0xb1b
> mlid....................0xc000
> mtu.....................0x84
> TClass..................0x0
> pkey....................0xffff
> rate....................0x83
> pkt_life................0x92
> SL......................0x0
> FlowLabel...............0x0
> HopLimit................0x0
> Scope...................0x0
> JoinState...............0x1
> ProxyJoin...............0x0
> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---

Applied, thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
