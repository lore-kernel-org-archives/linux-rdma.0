From: dotan-Hqos5LYUzRNWk0Htik3J/w@public.gmane.org
Subject: Re: ibv_create_qp() and max_inline_data behavior
Date: Wed, 28 Aug 2013 13:45:17 -0400
Message-ID: <dd17b84e216b2b8d578fca0f6fd0567b.squirrel@email.fatcow.com>
References: <d7685e13978f93890b2939c5ac2d5c7f@meuh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <d7685e13978f93890b2939c5ac2d5c7f-zgzEX58YAwA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dotan Barak <dotanba-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, dotan-Hqos5LYUzRNWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Yann.


>
> I'd like the behavior of ibv_create_qp() regarding cap.max_inline_data
> be clearer:
>
> 1) Should ibv_create_qp() failed if max_inline_data requested being
> greater than supported ?
Since the max_inline_data is an extension, the InfiniBand spec doesn't
specify the expected behavior.  However, the spirit of the spec is to
return a failure if not all of the requested attributes can be satisfied.

>
> If not
>
> 2) Should ibv_create_qp() be allowed to return a value less than the
> value requested ?
Please see my above answer.

>
> The fix would be different:
>
> 1) will require a small change to __ibv_create_qp() to enforce this
> behavor.
>
> 2) will only require a small update to the documentation to allow
> max_inline_data to be lower than requested.

The problem is that there isn't any description to the behavior of the low
level drivers. Different low level drivers can behave differently and
return different values. I tried to describe in the man pages/blog, what I
think is the best behavior (and this behavior is implemented by the low
level drivers of Mellanox devices).


Thanks
Dotan

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
