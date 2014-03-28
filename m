From: sagi grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: Kernel oops/panic with NFS over RDMA mount after disrupted Infiniband
 connection
Date: Sat, 29 Mar 2014 02:06:47 +0300
Message-ID: <53360087.9060902@mellanox.com>
References: <5332D425.3030803@ims.co.at> <4E6350BB-5E9C-40D9-8624-6CAA78E5B902@oracle.com> <lh0le0$u5$1@ger.gmane.org> <B7D4A29C-5E1F-4B6C-A8FC-C46D8DF6A87D@oracle.com> <5335440A.9030207@ims.co.at> <3FF5D87A-8199-4CE1-BF97-82DC61E4F480@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3FF5D87A-8199-4CE1-BF97-82DC61E4F480-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Senn Klemens <klemens.senn-cv18SyjCLaheoWH0uzbU5w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 3/29/2014 1:30 AM, Chuck Lever wrote:
> On Mar 28, 2014, at 2:42 AM, Senn Klemens <klemens.senn-cv18SyjCLaheoWH0uzbU5w@public.gmane.org> wr=
ote:
>
>> Hi Chuck,
>>
>> On 03/27/2014 04:59 PM, Chuck Lever wrote:
>>> Hi-
>>>
>>>
>>> On Mar 27, 2014, at 12:53 AM, Reiter Rafael <rafael.reiter-cv18SyjCLag@public.gmane.org=
t> wrote:
>>>
>>>> On 03/26/2014 07:15 PM, Chuck Lever wrote:
>>>>> Hi Rafael-
>>>>>
>>>>> I=92ll take a look. Can you report your HCA and how you reproduce=
 this issue?
>>>> The HCA is Mellanox Technologies MT26428.
>>>>
>>>> Reproduction:
>>>> 1) Mount a directory via NFS/RDMA
>>>> mount -t nfs -o port=3D20049,rdma,vers=3D4.0,timeo=3D900 172.16.10=
0.2:/ /mnt/
>> An additional "ls /mnt" is needed here (between step 1 and 2)
>>
>>>> 2) Pull the Infiniband cable or use ibportstate to disrupt the Inf=
iniband connection
>>>> 3) ls /mnt
>>>> 4) wait 5-30 seconds
>>> Thanks for the information.
>>>
>>> I have that HCA, but I won=92t have access to my test systems for a=
 week (traveling). So can you try this:
>>>
>>> # rpcdebug -m rpc -s trans
>>>
>>> then reproduce (starting with step 1 above). Some debugging output =
will appear at the tail of /var/log/messages. Copy it to this thread.
>>>
>> The output of /var/log/messages is:
>>
>> [  143.233701] RPC:  1688 xprt_rdma_allocate: size 1112 too large fo=
r
>> buffer[1024]: prog 100003 vers 4 proc 1
>> [  143.233708] RPC:  1688 xprt_rdma_allocate: size 1112, request
>> 0xffff88105894c000
>> [  143.233715] RPC:  1688 rpcrdma_inline_pullup: pad 0 destp
>> 0xffff88105894d7dc len 124 hdrlen 124
>> [  143.233718] RPC:       rpcrdma_register_frmr_external: Using frmr
>> ffff88084e589260 to map 1 segments
>> [  143.233722] RPC:  1688 rpcrdma_create_chunks: reply chunk elem
>> 652@0x105894d92c:0xced01 (last)
>> [  143.233725] RPC:  1688 rpcrdma_marshal_req: reply chunk: hdrlen 4=
8
>> rpclen 124 padlen 0 headerp 0xffff88105894d100 base 0xffff88105894d7=
60
>> lkey 0x8000
>> [  143.233785] RPC:       rpcrdma_event_process: event rep
>> ffff88084e589260 status 0 opcode 8 length 0
>> [  177.272397] RPC:       rpcrdma_event_process: event rep
>> (null) status C opcode FFFF8808 length 4294967295
>> [  177.272649] RPC:       rpcrdma_event_process: event rep
>> ffff880848ed0000 status 5 opcode FFFF8808 length 4294936584
> The mlx4 provider is returning a WC completion status of
> IB_WC_WR_FLUSH_ERR.
>
>> [  177.272651] RPC:       rpcrdma_event_process: WC opcode -30712 st=
atus
>> 5, connection lost
> -30712 is a bogus WC opcode. So the mlx4 provider is not filling in t=
he
> WC opcode. rpcrdma_event_process() thus can=92t depend on the content=
s of
> the ib_wc.opcode field when the WC completion status !=3D IB_WC_SUCCE=
SS.

Hey Chuck,

That is correct, the opcode field in the wc is not reliable in FLUSH er=
rors.

>
> A copy of the opcode reachable from the incoming rpcrdma_rep could be
> added, initialized in the forward paths. rpcrdma_event_process() coul=
d
> use the copy in the error case.

How about suppressing completions alltogether for fast_reg and local_in=
v=20
work requests?
if these shall fail you will get an error completion and the QP will=20
transition to error state
generating FLUSH_ERR completions for all pending WRs. In this case, you=
=20
can just ignore
flush fast_reg + local_inv errors.

see http://marc.info/?l=3Dlinux-rdma&m=3D139047309831997&w=3D2

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
