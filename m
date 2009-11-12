From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [infiniband-diags] [PATCH] [2/2] split out scan specific data from ibnd_node_t
Date: Thu, 12 Nov 2009 15:10:54 -0800
Message-ID: <E5EA56B85CF4411FA73984A608918052@amr.corp.intel.com>
References: <1257190401.580.31.camel@auk31.llnl.gov> <1257196316.580.33.camel@auk31.llnl.gov> <20091106181633.GQ7192@me> <1257532494.18550.89.camel@auk31.llnl.gov> <20091112163105.GI7192@me> <20091112105930.4248e521.weiny2@llnl.gov> <20091112225956.GA7192@me>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091112225956.GA7192@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Sasha Khapyorsky' <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: Al Chu <chu11-i2BcT+NCU+M@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>> Making things "private" allows us to change the library without breaking the
>> interface.
>
>I don't think
>
>> Furthermore, it simplifies the interface for users who want to
>> write code at a higher level.
>
>I'm not asking to make high level life harder :). My point is to not
>prevent from advanced developers to use available low level too,
>especially when such preventing requires some extra efforts.

I haven't been following the details of this thread, but it's very common to
expose only a portion of a data structure to the user, while keeping some of it
private.  As long as the lower library allocates the structure and exchanges
pointers, the interface can be maintained.

Trying to expose what should be internal data structures through a public
interface tosses encapsulation out the window, along with any benefits that it
provides.  In the end, all you get is a poorly designed interface.

Advanced developers can use lower level interfaces, like mad or umad.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
