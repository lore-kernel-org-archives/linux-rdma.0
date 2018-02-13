From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-rc 01/15] IB/ipoib: Do not warn if IPoIB debugfs
 doesn't exist
Date: Tue, 13 Feb 2018 13:45:47 -0500
Message-ID: <2cfd8ca0-3a29-2f1d-f95f-404da28eb9e2@intel.com>
References: <20180213101841.20101-1-leon@kernel.org>
 <20180213101841.20101-2-leon@kernel.org>
 <a95eace1-2e3e-e97a-cbaa-ca58771e5cff@intel.com>
 <20180213181205.GV2197@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180213181205.GV2197-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 2/13/2018 1:12 PM, Leon Romanovsky wrote:
> On Tue, Feb 13, 2018 at 11:06:02AM -0500, Dennis Dalessandro wrote:
>> On 2/13/2018 5:18 AM, Leon Romanovsky wrote:
>>>    	struct ipoib_dev_priv *priv = ipoib_priv(dev);
>>> -	WARN_ONCE(!priv->mcg_dentry, "null mcg debug file\n");
>>> -	WARN_ONCE(!priv->path_dentry, "null path debug file\n");
>>>    	debugfs_remove(priv->mcg_dentry);
>>>    	debugfs_remove(priv->path_dentry);
>>>    	priv->mcg_dentry = priv->path_dentry = NULL;
>>>
>>
>> Do we really want to keep sending stuff like this for RC? I get that it's a
>> trivial patch and all, but it's not actually fixing anything. Just a console
>> spam that only happens once.
> 
> It is more than simple console spam, but actual crash on the system with
> warning == panic.

Ok. I'll buy that.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
