From: Steve Wise <swise@opengridcomputing.com>
Subject: Re: [PATCH RFC iproute2-next 1/2] rdma: add 'link add/delete'
 commands
Date: Wed, 28 Nov 2018 14:23:43 -0600
Message-ID: <be951bde-9498-7d96-92bf-f6d8280aed68@opengridcomputing.com>
References: <cover.1543422310.git.swise@opengridcomputing.com>
 <7026be07534b14fd74e592c315523c57fde05a0a.1543422310.git.swise@opengridcomputing.com>
 <20181128182645.GJ4559@mtr-leonro.mtl.com>
 <fcc5af3c-4440-93ac-e6b4-212f5d1fbfe0@opengridcomputing.com>
 <a55d4291-7c60-dc64-54ef-5ffaf60ed2e6@opengridcomputing.com>
 <20181128200204.GO4559@mtr-leonro.mtl.com>
 <20181128200844.GQ4559@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181128200844.GQ4559@mtr-leonro.mtl.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: dsahern@gmail.com, stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, BMT@zurich.ibm.com
List-Id: linux-rdma@vger.kernel.org



On 11/28/2018 2:08 PM, Leon Romanovsky wrote:
> On Wed, Nov 28, 2018 at 10:02:04PM +0200, Leon Romanovsky wrote:
>> On Wed, Nov 28, 2018 at 01:34:14PM -0600, Steve Wise wrote:
>>> ...
>>>
>>>>>> +	rd_prepare_msg(rd, RDMA_NLDEV_CMD_NEWLINK, &seq,
>>>>>> +		       (NLM_F_REQUEST | NLM_F_ACK));
>>>>>> +	mnl_attr_put_strz(rd->nlh, RDMA_NLDEV_ATTR_DEV_NAME, name);
>>>>>> +	mnl_attr_put_strz(rd->nlh, RDMA_NLDEV_ATTR_LINK_TYPE, type);
>>>>>> +	mnl_attr_put_strz(rd->nlh, RDMA_NLDEV_ATTR_NDEV_NAME, dev);
>>>>>> +	ret = rd_send_msg(rd);
>>>>>> +	if (ret)
>>>>>> +		return ret;
>>>>>> +
>>>>>> +	ret = rd_recv_msg(rd, link_add_parse_cb, rd, seq);
>>>>>> +	if (ret)
>>>>>> +		perror(NULL);
>>>>> Why do you need rd_recv_msg()? I think that it is not needed, at least
>>>>> for rename, I didn't need it.
>>>>> https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/tree/rdma/dev.c#n244
>>>> To get the response of if it was successfully added.  It provides the
>>>> errno value.
>>> If I don't do the rd_recv_msg, then adding the same name twice fails
>>> without any error notification.  Ditto for deleting a non-existent
>>> link.  So the rd_recv_msg() allows getting the failure reason (and
>>> detecting the failure). 
>>>
>> Shouldn't extack provide such information as part of NLM_F_ACK flag?
>>
>> just shooting into the air, will take more close look tomorrow.
> OK, it was easier than I thought.
>
> You are right, need both send and receive to get the reason.
>
> Can you prepare general function and update rename part too?
> Something like send_receive(...) with dummy callback for receive path.
>
> Thanks

Sure, I'll whip something up for the next version of the patch series...
