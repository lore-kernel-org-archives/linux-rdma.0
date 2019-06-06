From: Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH RFC] svcrdma: Ignore source port when computing DRC hash
Date: Thu, 06 Jun 2019 13:08:03 +0000
Message-ID: <20190606130804.19EE32070B@mail.kernel.org>
References: <20190605121518.2150.26479.stgit@klimt.1015granger.net>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190605121518.2150.26479.stgit@klimt.1015granger.net>
Sender: stable-owner@vger.kernel.org
To: Sasha Levin <sashal@kernel.org>, Chuck Lever <chuck.lever@oracle.com>, linux-rdma@vger.kernel.org, linux-nfs@vger.kernel.org
Cc: stable@vger.kernel.orgstable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Hi,

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.1.7, v5.0.21, v4.19.48, v4.14.123, v4.9.180, v4.4.180.

v5.1.7: Build OK!
v5.0.21: Build OK!
v4.19.48: Build OK!
v4.14.123: Build OK!
v4.9.180: Build failed! Errors:
    net/sunrpc/xprtrdma/svc_rdma_transport.c:712:2: error: implicit declaration of function ‘rpc_set_port’; did you mean ‘rpc_net_ns’? [-Werror=implicit-function-declaration]

v4.4.180: Build failed! Errors:
    net/sunrpc/xprtrdma/svc_rdma_transport.c:635:2: error: implicit declaration of function ‘rpc_set_port’; did you mean ‘rpc_net_ns’? [-Werror=implicit-function-declaration]


How should we proceed with this patch?
