From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 1/1] opensm/main.c: opensm cannot be killed while
 asking for port guid
Date: Fri, 13 Nov 2009 15:03:08 +0200
Message-ID: <20091113130308.GM7192@me>
References: <4AF46DEB.7090105@sgi.com>
 <20091113025527.GE7192@me>
 <20091112192422.E16537@viper.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091112192422.E16537-NOE8RvUWeBY4qRZnexmlh9BPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sammy Wilborn <samm-sJ/iWh9BUns@public.gmane.org>
Cc: Michael Reed <mdr-sJ/iWh9BUns@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jeremy Higdon <jeremy-sJ/iWh9BUns@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 19:24 Thu 12 Nov     , Sammy Wilborn wrote:
> > > -		printf("\nError: Lame choice!\n");
> > > +		printf("\nError: Please try again.\n");
> > 
> > "Try again" is good, but it is useful to provide a reason too, so let's
> > do it even more "professional":
> > 
> > 	printf("\nError: Lame choice! Please try again.\n");
> 
> How about the following?
> 
>  	printf("\nError: Invalid choice! Please try again.\n");

This works too. Would you care about the patch?

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
