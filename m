From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 0/2] opensm: Bug fixes for torus-2QoS patchset
Date: Tue, 30 Nov 2010 16:53:09 +0200
Message-ID: <20101130145309.GC11898@me>
References: <1284742994-24503-1-git-send-email-jaschut@sandia.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1284742994-24503-1-git-send-email-jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 11:03 Fri 17 Sep     , Jim Schutt wrote:
> Hi Sasha,
> 
> These patches fix bugs discovered during further testing of the
> torus-2QoS routing module for OpenSM.  They apply to your
> torus-2qos branch.
> 
> Thanks -- Jim
> 
> 
> Jim Schutt (2):
>   opensm/osm_torus.c: Add check for invalid topology discovery due to
>     user misconfiguration.
>   opensm/osm_torus.c: Handle calloc() failure on routing engine context
>     creation.
> 
>  opensm/opensm/osm_torus.c |   24 +++++++++++++++++++++++-
>  1 files changed, 23 insertions(+), 1 deletions(-)

Applied. Thanks.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
