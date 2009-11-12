From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [ofw] Re: [PATCH] osm_subnet.c
Date: Thu, 12 Nov 2009 11:23:43 -0800
Message-ID: <81D21ED9D6F34BC1B7DA64F50EE5A7DD@amr.corp.intel.com>
References: <3F6F638B8D880340AB536D29CD4C1E1912C86E8A8F@orsmsx501.amr.corp.intel.com> <20091004001316.GK17846@me> <A6E929B3F38F455EB28EB478FBAF290E@amr.corp.intel.com> <20091112191811.GO7192@me>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091112191811.GO7192@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Sasha Khapyorsky' <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>	int compar(const void *, const void *);
>
>, or to not bother at all and leave it as 'long'.
>
>Hmm, I would prefer to change to 'int' to prevent future confusing.
>Thoughts?

int seems to make the most sense to me.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
