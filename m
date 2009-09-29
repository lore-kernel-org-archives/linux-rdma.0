From: "Eli Dorfman (Voltaire)" <dorfman.eli@gmail.com>
Subject: Re: [ofa-general] [PATCH] infiniband-diags: Fix IB network discovery
	from switch node.
Date: Tue, 29 Sep 2009 18:16:21 +0200
Message-ID: <4AC232D5.2060806@gmail.com>
References: <4A9548AA.4020900@gmail.com>
	<20090923172451.fb20ab9b.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <general-bounces@lists.openfabrics.org>
In-Reply-To: <20090923172451.fb20ab9b.weiny2@llnl.gov>
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
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, OpenIB <general@lists.openfabrics.org>
List-Id: linux-rdma@vger.kernel.org

Ira Weiny wrote:
> Eli,
> 
> On Wed, 26 Aug 2009 17:37:30 +0300
> "Eli Dorfman (Voltaire)" <dorfman.eli@gmail.com> wrote:
> 
>> Subject: [PATCH] Fix IB network discovery from switch node.
> 
> Sorry for the late inquiry on this but what exactly was the bug here?

Sorry for the late response.
The problem is related to wrong discovery when running from the switch.
Without the patch ibnetdiscover finds only local switch

4036% ibnetdiscover

ibwarn: [2833] mad_rpc: _do_madrpc failed; dport (DR path slid 0; dlid 0; 0,0)
ibwarn: [2833] get_remote_node: NodeInfo on DR path slid 0; dlid 0; 0,0 failed, skipping port
#
# Topology file: generated on Tue Sep 29 15:29:50 2009
#
# Max of 1 hops discovered
# Initiated from node 0008f1050010006e port 0008f1050010006e

vendid=0x8f1
devid=0x5a5a
sysimgguid=0x8f1050010006f
switchguid=0x8f1050010006e(8f1050010006e)
Switch  36 "S-0008f1050010006e"         # "Voltaire 4036 - 36 QDR ports switch" enhanced port 0 lid 1 lmc 0


With the patch we see the switch is connected to 2 HCAs

#
# Topology file: generated on Tue Sep 29 15:19:24 2009
#
# Max of 1 hops discovered
# Initiated from node 0008f1050010006e port 0008f1050010006e

vendid=0x8f1
devid=0x5a5a
sysimgguid=0x8f1050010006f
switchguid=0x8f1050010006e(8f1050010006e)
Switch  36 "S-0008f1050010006e"         # "Voltaire 4036 - 36 QDR ports switch" enhanced port 0 lid 1 lmc 0
[24]    "H-0008f104039a0198"[2](8f104039a019a)          # "luna6 HCA-1" lid 3 4xQDR
[29]    "H-0008f1040399f444"[2](8f1040399f446)          # "localhost HCA-1" lid 2 4xQDR

vendid=0x2c9
devid=0x673c
sysimgguid=0x8f1040399f447
caguid=0x8f1040399f444
Ca      2 "H-0008f1040399f444"          # "localhost HCA-1"
[2](8f1040399f446)      "S-0008f1050010006e"[29]                # lid 2 lmc 0 "Voltaire 4036 - 36 QDR ports switch" lid 1 4xQDR

vendid=0x2c9
devid=0x673c
sysimgguid=0x8f104039a019b
caguid=0x8f104039a0198
Ca      2 "H-0008f104039a0198"          # "luna6 HCA-1"
[2](8f104039a019a)      "S-0008f1050010006e"[24]                # lid 3 lmc 0 "Voltaire 4036 - 36 QDR ports switch" lid 1 4xQDR

> 
> I just found that this change introduced a bug.  The problem is that if you
> don't do this query, even when the first found node is a switch, the port you
> came into the switch on will not get reported properly.  Here is what I mean.
> 
> Running with the current master:
> 
> 17:19:42 > ./iblinkinfo -S 0x000b8cffff00490c
> Switch 0x000b8cffff00490c MT47396 Infiniscale-III Mellanox Technologies:
>            8    1[  ] ==( 4X 2.5 Gbps   Down/ Polling)==>             [  ] "" ( )
> ...
>            8    9[  ] ==( 4X 2.5 Gbps   Down/ Polling)==>             [  ] "" ( )
>            8   10[  ] ==( 4X 5.0 Gbps Active/  LinkUp)==>      15   24[  ] "ISR9024D Voltaire" ( )
>            8   11[  ] ==( 4X 2.5 Gbps   Down/ Polling)==>             [  ] "" ( )
>            8   12[  ] ==( 4X 5.0 Gbps Active/  LinkUp)==>             [  ] "" ( )
>            8   13[  ] ==( 4X 2.5 Gbps   Down/ Polling)==>             [  ] "" ( )
> ...
> 
> The DR path "came in" on port 12 and is reported as Active/LinkUp but has no
> information on the other end.  Here is what the output should look like with
> your change removed.
> 
> 17:22:36 > ./iblinkinfo -S 0x000b8cffff00490c
> Switch 0x000b8cffff00490c MT47396 Infiniscale-III Mellanox Technologies:
>            8    1[  ] ==( 4X 2.5 Gbps   Down/ Polling)==>             [  ] "" ( )
> ...
>            8    9[  ] ==( 4X 2.5 Gbps   Down/ Polling)==>             [  ] "" ( )
>            8   10[  ] ==( 4X 5.0 Gbps Active/  LinkUp)==>      15   24[  ] "ISR9024D Voltaire" ( )
>            8   11[  ] ==( 4X 2.5 Gbps   Down/ Polling)==>             [  ] "" ( )
>            8   12[  ] ==( 4X 5.0 Gbps Active/  LinkUp)==>       7    8[  ] "Cisco Switch SFS7000D" ( )
>            8   13[  ] ==( 4X 2.5 Gbps   Down/ Polling)==>             [  ] "" ( )
> ...
> 
> This properly reports the other end of this link as another switch.
> 
> Could you explain the problem a bit more so we can come up with a better
> solution?

I think that the problem is related to NodeInfo:LocalPort which is 0 in case of a switch.
I see that get_remote_node() sends direct route MAD to switch with path 0,0 and that fails (at least for Mellanox IS4 switch chips).
Another way to bypass this may be as follows:

diff --git a/infiniband-diags/libibnetdisc/src/ibnetdisc.c b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
index 1e93ff8..3dd0dc6 100644
--- a/infiniband-diags/libibnetdisc/src/ibnetdisc.c
+++ b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
@@ -461,7 +461,7 @@ get_remote_node(struct ibnd_fabric *fabric, struct ibnd_node *node, struct ibnd_
 			!= IB_PORT_PHYS_STATE_LINKUP)
 		return -1;
 
-	if (extend_dpath(fabric, path, portnum) < 0)
+	if (portnum > 0 && extend_dpath(fabric, path, portnum) < 0)
 		return -1;
 
 	if (query_node(fabric, &node_buf, &port_buf, path)) {


Please check whether this is OK and I can send a new patch.

Thanks,
Eli


> 
> Thanks,
> Ira
> 
>> Signed-off-by: Eli Dorfman <elid@voltaire.com>
>> ---
>>  infiniband-diags/libibnetdisc/src/ibnetdisc.c |   16 +++++++++-------
>>  1 files changed, 9 insertions(+), 7 deletions(-)
>>
>> diff --git a/infiniband-diags/libibnetdisc/src/ibnetdisc.c b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
>> index c69467e..779e659 100644
>> --- a/infiniband-diags/libibnetdisc/src/ibnetdisc.c
>> +++ b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
>> @@ -590,13 +590,15 @@ ibnd_fabric_t *ibnd_discover_fabric(struct ibmad_port * ibmad_port,
>>  	if (!port)
>>  		goto error;
>>  
>> -	rc = get_remote_node(ibmad_port, fabric, node, port, from,
>> -			     mad_get_field(node->info, 0,
>> -					   IB_NODE_LOCAL_PORT_F), 0);
>> -	if (rc < 0)
>> -		goto error;
>> -	if (rc > 0)		/* non-fatal error, nothing more to be done */
>> -		return ((ibnd_fabric_t *) fabric);
>> +	if (node->node.type != IB_NODE_SWITCH) { 
>> +		rc = get_remote_node(ibmad_port, fabric, node, port, from,
>> +				     mad_get_field(node->info, 0,
>> +						   IB_NODE_LOCAL_PORT_F), 0);
>> +		if (rc < 0)
>> +			goto error;
>> +		if (rc > 0)		/* non-fatal error, nothing more to be done */
>> +			return ((ibnd_fabric_t *) fabric);
>> +	}
>>  
>>  	for (dist = 0; dist <= max_hops; dist++) {
>>  
>> -- 
>> 1.5.5
>>
>> _______________________________________________
>> general mailing list
>> general@lists.openfabrics.org
>> http://*lists.openfabrics.org/cgi-bin/mailman/listinfo/general
>>
>> To unsubscribe, please visit http://*openib.org/mailman/listinfo/openib-general
>>
> 
> 
