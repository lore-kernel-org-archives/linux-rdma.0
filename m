From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next] RDMA/qedr: Fix rdma_type initialization
Date: Mon, 25 Sep 2017 08:29:58 -0400
Message-ID: <1a07af53-0729-956e-129c-2c914e0e3d0c@intel.com>
References: <1505842717-26646-1-git-send-email-Michal.Kalderon@cavium.com>
 <20170919174721.GL5788@mtr-leonro.local>
 <CY1PR0701MB2012B48FC05034ED663DB1D188610@CY1PR0701MB2012.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CY1PR0701MB2012B48FC05034ED663DB1D188610-UpKza+2NMNLHMJvQ0dyT705OhdzP3rhOnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 9/20/2017 1:42 AM, Kalderon, Michal wrote:
> From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Sent: Tuesday, September 19, 2017 8:47 PM
> 
> On Tue, Sep 19, 2017 at 08:38:37PM +0300, Michal Kalderon wrote:
>>> Initialize the rdma_type (iWARP or RoCE) which is set according to
>>> device configuration in qed.
>>>
>>> Signed-off-by: Michal Kalderon <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
>>> Signed-off-by: Ariel Elior <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
>>> ---
>>
>> Please add Fixes.
>>
>> Thanks
> sure, i'll send v1

Does just responding with a "Fixes" tag get appended automagically by 
Patchworks?

-Denny

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
