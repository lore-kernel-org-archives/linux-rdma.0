From: Saeed Mahameed <saeedm@dev.mellanox.co.il>
Subject: Re: [PATCH for-next V2 00/11] Mellanox mlx5 core and ODP updates 2017-01-01
Date: Tue, 3 Jan 2017 01:30:16 +0200
Message-ID: <CALzJLG9ZBRMOVqFsTypCLV6Rrek8a9g43z0spvVKeku6WdWCTA@mail.gmail.com>
References: <1483349868-11716-1-git-send-email-saeedm@mellanox.com> <20170102.155341.1496970446718890403.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20170102.155341.1496970446718890403.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: Saeed Mahameed <saeedm@mellanox.com>, Doug Ledford <dledford@redhat.com>, Linux Netdev List <netdev@vger.kernel.org>, linux-rdma@vger.kernel.org, Leon Romanovsky <leonro@mellanox.com>, ilyal@mellanox.com, artemyko@mellanox.com
List-Id: linux-rdma@vger.kernel.org

On Mon, Jan 2, 2017 at 10:53 PM, David Miller <davem@davemloft.net> wrote:
> From: Saeed Mahameed <saeedm@mellanox.com>
> Date: Mon,  2 Jan 2017 11:37:37 +0200
>
>> The following eleven patches mainly come from Artemy Kovalyov
>> who expanded mlx5 on-demand-paging (ODP) support. In addition
>> there are three cleanup patches which don't change any functionality,
>> but are needed to align codebase prior accepting other patches.
>
> Series applied to net-next, thanks.

Whoops,

This series was meant as a pull request, you can blame it on me I
kinda messed up the V2 title.
Doug will have to pull same patches later, will this produce a
conflict on merge window ?

Sorry for the confusion.
