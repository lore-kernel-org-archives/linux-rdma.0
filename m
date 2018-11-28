From: Steve Wise <swise@opengridcomputing.com>
Subject: Re: [PATCH RFC iproute2-next 1/2] rdma: add 'link add/delete'
 commands
Date: Wed, 28 Nov 2018 13:34:14 -0600
Message-ID: <a55d4291-7c60-dc64-54ef-5ffaf60ed2e6@opengridcomputing.com>
References: <cover.1543422310.git.swise@opengridcomputing.com>
 <7026be07534b14fd74e592c315523c57fde05a0a.1543422310.git.swise@opengridcomputing.com>
 <20181128182645.GJ4559@mtr-leonro.mtl.com>
 <fcc5af3c-4440-93ac-e6b4-212f5d1fbfe0@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <fcc5af3c-4440-93ac-e6b4-212f5d1fbfe0@opengridcomputing.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: dsahern@gmail.com, stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, BMT@zurich.ibm.com
List-Id: linux-rdma@vger.kernel.org

...

>>> +	rd_prepare_msg(rd, RDMA_NLDEV_CMD_NEWLINK, &seq,
>>> +		       (NLM_F_REQUEST | NLM_F_ACK));
>>> +	mnl_attr_put_strz(rd->nlh, RDMA_NLDEV_ATTR_DEV_NAME, name);
>>> +	mnl_attr_put_strz(rd->nlh, RDMA_NLDEV_ATTR_LINK_TYPE, type);
>>> +	mnl_attr_put_strz(rd->nlh, RDMA_NLDEV_ATTR_NDEV_NAME, dev);
>>> +	ret = rd_send_msg(rd);
>>> +	if (ret)
>>> +		return ret;
>>> +
>>> +	ret = rd_recv_msg(rd, link_add_parse_cb, rd, seq);
>>> +	if (ret)
>>> +		perror(NULL);
>> Why do you need rd_recv_msg()? I think that it is not needed, at least
>> for rename, I didn't need it.
>> https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/tree/rdma/dev.c#n244
> To get the response of if it was successfully added.  It provides the
> errno value.
If I don't do the rd_recv_msg, then adding the same name twice fails
without any error notification.  Ditto for deleting a non-existent
link.  So the rd_recv_msg() allows getting the failure reason (and
detecting the failure). 
