From: Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH iproute2 V3 0/4] RDMAtool
Date: Mon, 10 Jul 2017 09:43:25 +0200
Message-ID: <20170710074325.GA1853@nanopsycho>
References: <20170704075541.12544-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170704075541.12544-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Stephen Hemminger <stephen@networkplumber.org>, Doug Ledford <dledford@redhat.com>, Ariel Almog <ariela@mellanox.com>, Linux RDMA <linux-rdma@vger.kernel.org>, Linux Netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

Tue, Jul 04, 2017 at 09:55:37AM CEST, leon@kernel.org wrote:
>Hi,
>
>This is third version of series implementing the RDAMtool -  the tool

s/RDAMtool/RDMAtool/


>to configure RDMA devices. The initial proposal was sent as RFC [1] and
>was based on sysfs entries as POC.
>
>The current series was rewritten completely to work with RDMA netlinks as
>a source of user<->kernel communications. In order to achieve that, the
>RDMA netlinks were extensively refactored and modernized [2, 3, 4 and 5].
>
>The following is an example of various runs on my machine with 5 devices
>(4 in IB mode and one in Ethernet mode)
>
>### Without parameters
>$ rdma
>Usage: rdma [ OPTIONS ] OBJECT { COMMAND | help }
>where  OBJECT := { dev | link | help }
>       OPTIONS := { -V[ersion] | -d[etails]}

Do you plan to add "mon" any time soon?
