From: Sridhar Samudrala <sri-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/16] librdmacm/rsocket: Fix hang in rrecv/rsend after
 disconnecting
Date: Wed, 30 May 2012 16:55:21 -0700
Message-ID: <4FC6B369.90100@us.ibm.com>
References: <1828884A29C6694DAF28B7E6B8A8237346A24BE7@ORSMSX101.amr.corp.intel.com> <4FC6709C.70304@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4FC6709C.70304-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pradeep Satyanarayana <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 5/30/2012 12:10 PM, Pradeep Satyanarayana wrote:
> On 05/30/2012 10:21 AM, Hefty, Sean wrote:
>> If a user calls rrecv() after a blocking rsocket has been disconnected,
>> it will hang.  This problem and the cause was reported by Sridhar 
>> Samudrala
>> <samudrala-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>.  It can be reproduced by running netserver -f -D
>> using the rs-preload library.  A similar issue exists with rsend().
>>
>> Fix this by not blocking on a CQ unless we're connected.
>>
>> Signed-off-by: Sean Hefty<sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> ---
>> Sridhar, can you please let me know if this fixes the hang you were 
>> seeing?
>> I moved the connected check inside holding the cq lock from the patch 
>> that
>> you sent me.
>>
>>   src/rsocket.c |   26 +++++++++++++++++++++++---
>>   1 files changed, 23 insertions(+), 3 deletions(-)
>>
>> diff --git a/src/rsocket.c b/src/rsocket.c
>> index 01b7248..8c96dc1 100644
>> --- a/src/rsocket.c
>> +++ b/src/rsocket.c
>> @@ -908,6 +908,11 @@ static int rs_can_send(struct rsocket *rs)
>>              (rs->target_sgl[rs->target_sge].length != 0);
>>   }
>>
>> +static int rs_conn_can_send(struct rsocket *rs)
>> +{
>> +    return rs_can_send(rs) || (rs->state != rs_connected);
>> +}
>> +
>>   static int rs_can_send_ctrl(struct rsocket *rs)
>>   {
>>       return rs->ctrl_avail;
>> @@ -918,6 +923,11 @@ static int rs_have_rdata(struct rsocket *rs)
>>       return (rs->rmsg_head != rs->rmsg_tail);
>>   }
>>
>> +static int rs_conn_have_rdata(struct rsocket *rs)
>> +{
>> +    return rs_have_rdata(rs) || (rs->state != rs_connected);
>> +}
>> +
>>   static int rs_all_sends_done(struct rsocket *rs)
>>   {
>>       return (rs->sqe_avail + rs->ctrl_avail) == RS_QP_SIZE;
>> @@ -980,7 +990,7 @@ ssize_t rrecv(int socket, void *buf, size_t len, 
>> int flags)
>>       }
>>       fastlock_acquire(&rs->rlock);
>>       if (!rs_have_rdata(rs)) {
>> -        ret = rs_process_cq(rs, rs_nonblocking(rs, flags), 
>> rs_have_rdata);
>> +        ret = rs_process_cq(rs, rs_nonblocking(rs, flags), 
>> rs_conn_have_rdata);
>>           if (ret&&  errno != ECONNRESET)
>>               goto out;
>>       }
>> @@ -1084,9 +1094,14 @@ ssize_t rsend(int socket, const void *buf, 
>> size_t len, int flags)
>>       fastlock_acquire(&rs->slock);
>>       for (left = len; left; left -= xfer_size, buf += xfer_size) {
>>           if (!rs_can_send(rs)) {
>> -            ret = rs_process_cq(rs, rs_nonblocking(rs, flags), 
>> rs_can_send);
>> +            ret = rs_process_cq(rs, rs_nonblocking(rs, flags),
>> +                        rs_conn_can_send);
>>               if (ret)
>>                   break;
>> +            if (rs->state != rs_connected) {
>> +                ret = ERR(ECONNRESET);
>> +                break;
>> +            }
>>           }
>>
>>           if (olen<  left) {
>> @@ -1193,9 +1208,14 @@ static ssize_t rsendv(int socket, const struct 
>> iovec *iov, int iovcnt, int flags
>>       fastlock_acquire(&rs->slock);
>>       for (left = len; left; left -= xfer_size) {
>>           if (!rs_can_send(rs)) {
>> -            ret = rs_process_cq(rs, rs_nonblocking(rs, flags), 
>> rs_can_send);
>> +            ret = rs_process_cq(rs, rs_nonblocking(rs, flags),
>> +                        rs_conn_can_send);
>>               if (ret)
>>                   break;
>> +            if (rs->state != rs_connected) {
>> +                ret = ERR(ECONNRESET);
>> +                break;
>> +            }
>>           }
>>
>>           if (olen<  left) {
>>
>>
> Sean, Have tested by applying only this patch in the entire series. 
> netperf now seems to be working.
Yes. The patch fixes the hang in recv().
However, i still see a few other issues related to socket semantics that 
need to be addressed.

# ldp netperf  -H 192.168.0.198 -l 3 -t TCP_STREAM
MIGRATED TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 
192.168.0.198 (192.168.0.198) port 0 AF_INET
netperf: get_transport_info: getsockopt: errno 95
Recv   Send    Send
Socket Socket  Message  Elapsed
Size   Size    Size     Time     Throughput
bytes  bytes   bytes    secs.    10^6bits/sec

131072 131072 131072    3.00     6176.91
shutdown_control: no response received  errno 95

1. netperf: get_transport_info: getsockopt: errno 95
This failure is due to the missing TCP_MAXSEG socket option support. May 
be this is OK as this option
doesn't make much sense when using RDMA. Or we could return a reasonable 
value.

2. shutdown_control: no response received  errno 95
Here select() on control socket is failing with EOPNOTSUPP after doing a 
shutdown(SHUT_WR) of the control socket

3. Once in a while netserver timesout in recv() after the client closes 
the connection.

Thanks
Sridhar




--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
