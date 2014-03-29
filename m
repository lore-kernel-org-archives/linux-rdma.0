From: sagi grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: Kernel oops/panic with NFS over RDMA mount after disrupted Infiniband
 connection
Date: Sat, 29 Mar 2014 03:52:36 +0300
Message-ID: <53361954.4090304@mellanox.com>
References: <5332D425.3030803@ims.co.at> <4E6350BB-5E9C-40D9-8624-6CAA78E5B902@oracle.com> <lh0le0$u5$1@ger.gmane.org> <B7D4A29C-5E1F-4B6C-A8FC-C46D8DF6A87D@oracle.com> <5335440A.9030207@ims.co.at> <3FF5D87A-8199-4CE1-BF97-82DC61E4F480@oracle.com> <53360087.9060902@mellanox.com> <7C171419-2808-42C4-AD00-FF7E392E6E3F@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7C171419-2808-42C4-AD00-FF7E392E6E3F-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, sagi grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Senn Klemens <klemens.senn-cv18SyjCLaheoWH0uzbU5w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 3/29/2014 3:05 AM, Chuck Lever wrote:
> On Mar 28, 2014, at 4:06 PM, sagi grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote=
:
>
>> On 3/29/2014 1:30 AM, Chuck Lever wrote:
>>> On Mar 28, 2014, at 2:42 AM, Senn Klemens <klemens.senn-cv18SyjCLaheoWH0uzbU5w@public.gmane.org> =
wrote:
>>>
>>>> Hi Chuck,
>>>>
>>>> On 03/27/2014 04:59 PM, Chuck Lever wrote:
>>>>> Hi-
>>>>>
>>>>>
>>>>> On Mar 27, 2014, at 12:53 AM, Reiter Rafael <rafael.reiter-IhqiUyeJN0s@public.gmane.org=
=2Eat> wrote:
>>>>>
>>>>>> On 03/26/2014 07:15 PM, Chuck Lever wrote:
>>>>>>> Hi Rafael-
>>>>>>>
>>>>>>> I=92ll take a look. Can you report your HCA and how you reprodu=
ce this issue?
>>>>>> The HCA is Mellanox Technologies MT26428.
>>>>>>
>>>>>> Reproduction:
>>>>>> 1) Mount a directory via NFS/RDMA
>>>>>> mount -t nfs -o port=3D20049,rdma,vers=3D4.0,timeo=3D900 172.16.=
100.2:/ /mnt/
>>>> An additional "ls /mnt" is needed here (between step 1 and 2)
>>>>
>>>>>> 2) Pull the Infiniband cable or use ibportstate to disrupt the I=
nfiniband connection
>>>>>> 3) ls /mnt
>>>>>> 4) wait 5-30 seconds
>>>>> Thanks for the information.
>>>>>
>>>>> I have that HCA, but I won=92t have access to my test systems for=
 a week (traveling). So can you try this:
>>>>>
>>>>> # rpcdebug -m rpc -s trans
>>>>>
>>>>> then reproduce (starting with step 1 above). Some debugging outpu=
t will appear at the tail of /var/log/messages. Copy it to this thread.
>>>>>
>>>> The output of /var/log/messages is:
>>>>
>>>> [  143.233701] RPC:  1688 xprt_rdma_allocate: size 1112 too large =
for
>>>> buffer[1024]: prog 100003 vers 4 proc 1
>>>> [  143.233708] RPC:  1688 xprt_rdma_allocate: size 1112, request
>>>> 0xffff88105894c000
>>>> [  143.233715] RPC:  1688 rpcrdma_inline_pullup: pad 0 destp
>>>> 0xffff88105894d7dc len 124 hdrlen 124
>>>> [  143.233718] RPC:       rpcrdma_register_frmr_external: Using fr=
mr
>>>> ffff88084e589260 to map 1 segments
>>>> [  143.233722] RPC:  1688 rpcrdma_create_chunks: reply chunk elem
>>>> 652@0x105894d92c:0xced01 (last)
>>>> [  143.233725] RPC:  1688 rpcrdma_marshal_req: reply chunk: hdrlen=
 48
>>>> rpclen 124 padlen 0 headerp 0xffff88105894d100 base 0xffff88105894=
d760
>>>> lkey 0x8000
>>>> [  143.233785] RPC:       rpcrdma_event_process: event rep
>>>> ffff88084e589260 status 0 opcode 8 length 0
>>>> [  177.272397] RPC:       rpcrdma_event_process: event rep
>>>> (null) status C opcode FFFF8808 length 4294967295
>>>> [  177.272649] RPC:       rpcrdma_event_process: event rep
>>>> ffff880848ed0000 status 5 opcode FFFF8808 length 4294936584
>>> The mlx4 provider is returning a WC completion status of
>>> IB_WC_WR_FLUSH_ERR.
>>>
>>>> [  177.272651] RPC:       rpcrdma_event_process: WC opcode -30712 =
status
>>>> 5, connection lost
>>> -30712 is a bogus WC opcode. So the mlx4 provider is not filling in=
 the
>>> WC opcode. rpcrdma_event_process() thus can=92t depend on the conte=
nts of
>>> the ib_wc.opcode field when the WC completion status !=3D IB_WC_SUC=
CESS.
>> Hey Chuck,
>>
>> That is correct, the opcode field in the wc is not reliable in FLUSH=
 errors.
>>
>>> A copy of the opcode reachable from the incoming rpcrdma_rep could =
be
>>> added, initialized in the forward paths. rpcrdma_event_process() co=
uld
>>> use the copy in the error case.
>> How about suppressing completions alltogether for fast_reg and local=
_inv work requests?
>> if these shall fail you will get an error completion and the QP will=
 transition to error state
>> generating FLUSH_ERR completions for all pending WRs. In this case, =
you can just ignore
>> flush fast_reg + local_inv errors.
>>
>> see http://marc.info/?l=3Dlinux-rdma&m=3D139047309831997&w=3D2
> While considering your suggestion, I see that my proposed fix doesn=92=
t work. In the FAST_REG_MR and LOCAL_INV cases, wr_id points to a struc=
t rpcrdma_mw, not a struct rpcrdma_rep. Putting a copy of the opcode in=
 rpcrdma_rep would have no effect. Worse:
>
>>   158         if (IB_WC_SUCCESS !=3D wc->status) {
>>   159                 dprintk("RPC:       %s: WC opcode %d status %X=
, connection lost\n",
>>   160                         __func__, wc->opcode, wc->status);
>>   161                 rep->rr_len =3D ~0U;
> Suppose this is an IB_WC_FAST_REG_MR completion, so =93rep=94 here is=
 actually a struct rpcrdma_mw, not a struct rpcrdma_rep. Line 161 pokes=
 32 one-bits at the top of that struct rpcrdma_mw. If wc->opcode was al=
ways usable, we=92d at least have to fix that.

<nod>
So for error completions one needs to be careful dereferencing wr_id as=
=20
the opcode might not reliable. it will be better to first identify that=
=20
wr_id is indeed a pointer to rep.

>>   162                 if (wc->opcode !=3D IB_WC_FAST_REG_MR && wc->o=
pcode !=3D IB_WC_LOCAL_INV)
>>   163                         rpcrdma_schedule_tasklet(rep);
>>   164                 return;
>>   165         }
>>   166
>>   167         switch (wc->opcode) {
>>   168         case IB_WC_FAST_REG_MR:
>>   169                 frmr =3D (struct rpcrdma_mw *)(unsigned long)w=
c->wr_id;
>>   170                 frmr->r.frmr.state =3D FRMR_IS_VALID;
>>   171                 break;
>
> To make my initial solution work, you=92d have to add a field to both=
 struct rpcrdma_mw and struct rpcrdma_rep, and ensure they are at the s=
ame offset in both structures. Ewe.
>
> Eliminating completions for FAST_REG_MR and LOCAL_INV might be a pref=
erable way to address this.

Agree, Same applies for MW.

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
