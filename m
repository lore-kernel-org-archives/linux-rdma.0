From: "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: Re: [PATCHv2] OpenSM torus routing order list
Date: Mon, 2 May 2011 12:34:27 -0600
Message-ID: <4DBEF933.8050109@sandia.gov>
References: <20110321095823.GA22502@calypso.voltaire.com>
 <1300746824.7744.71.camel@sale659.sandia.gov>
 <20110502154131.GF2088@calypso.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110502154131.GF2088-iQai9MGU/dyyaiaB+Ve85laTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David McMillen <davem-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Alex Netes wrote:
> Enables to define list of switch ports so the SM will
> go over this list when creating a routing.
> It helps balancing links load on some communication patterns
> where multipile links connect between the switches.
> 
> Signed-off-by: David McMillen <davem-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
> Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Acked-by: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>

> ---
> Changes since v1:
> Added detailed description in man/torus-2QoS.conf.5.in
> Added error messages on configuration file parsing
> Fixed some styling
> ---
>  man/torus-2QoS.conf.5.in |   26 ++++++++++++++-
>  opensm/osm_torus.c       |   76 ++++++++++++++++++++++++++++++++++++++++++++--
>  2 files changed, 97 insertions(+), 5 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
